Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYJPWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYJPWhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbYJPWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:37:00 -0400
Received: from CPE-124-189-54-71.nsw.bigpond.net.au ([124.189.54.71]:49765
	"EHLO bunyip.billabong.weebeastie.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754708AbYJPWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:36:59 -0400
X-Greylist: delayed 2735 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 18:36:58 EDT
Date: Fri, 17 Oct 2008 08:51:12 +1100
From: CaT <cat@zip.com.au>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl processing
Message-ID: <20081016215112.GX19077@zip.com.au>
References: <20081016001721.GW19077@zip.com.au> <4B6A08C587958942AA3002690DD4F8C32D24DF36@cosmail02.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C32D24DF36@cosmail02.lsi.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 07:54:07AM -0600, Yang, Bo wrote:
> What MegaCli cmds did you using (DCMD or DCDB?).

MegaCli -LdPdInfo -a0 -NoLog

Forgot to mention that this is the 64bit version of the command.

-- 
  "Police noticed some rustling sounds from Linn's bottom area
  and on closer inspection a roll of cash was found protruding
  from Linn's anus, the full amount of cash taken in the robbery."
    - http://www.smh.com.au/news/world/robber-hides-loot-up-his-booty/2008/05/09/1210131248617.html
