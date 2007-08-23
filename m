Return-Path: <linux-kernel-owner+w=401wt.eu-S1765712AbXHWV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765712AbXHWV25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbXHWV2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:28:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41277 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761677AbXHWV2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:28:48 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <46CDE94A.7000600@googlemail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 23 Aug 2007 14:22:49 -0700
Message-Id: <1187904169.2435.83.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 22:08 +0200, Michal Piotrowski wrote:
> Hi Daniel,
> 
> Daniel Walker pisze:
> > On Wed, 2007-08-08 at 16:20 +0200, Björn Steinbrink wrote:
> >> On 2007.08.07 17:06:49 -0700, Daniel Walker wrote:
> >>> This patch below hangs my system on boot if I set nmi_watchdog=2 . It
> >>> shows the NMI as stuck then the system hangs .. nmi_watchdog=1 works
> >>> fine, and the system boots without any watchdog options ..
> >>>
> >>> The machine is an Intel allagash development board, and it has two dual
> >>> core Pentium-M cpus. I attached the .config I used.
> > 
> > Could we put this on the known regressions list? It was added in 2.6.21,
> > and still exists in lastest git (as of 15 min. ago) ..
> 
> Bugzilla should be a better place for this bug.

Ok.

> I don't have enough time to track bugs after release, so old lists are not
> maintained
> http://kernelnewbies.org/known_regressions_2622
> http://kernelnewbies.org/known_regressions_2621

Have you considered maintaining all the lists in Bugzilla? If you had a
search of open bugs they would just fall of the list as they get
closed.. 

Daniel

