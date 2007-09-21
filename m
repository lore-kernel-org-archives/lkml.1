Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbXIUA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbXIUA0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXIUA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:26:36 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:57186 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXIUA0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:26:36 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 10:24:34 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <20070920100941.GA12157@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20070920100941.GA12157@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211024.35991.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> Seems like good enough for -mm to me.
> 
> 									Pavel

Andrew, if I recall correctly, you said a while ago that you didn't want 
another hibernation implementation in the vanilla kernel. If you're going to 
consider merging this kexec code, will you also please consider merging 
TuxOnIce?

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
