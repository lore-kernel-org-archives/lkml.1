Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYAAXyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYAAXyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYAAXyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:54:14 -0500
Received: from kolab.mylinuxtime.de ([212.112.242.22]:43254 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYAAXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:54:13 -0500
X-Greylist: delayed 1433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 18:54:13 EST
X-Spam-ASN: AS24900 212.112.224.0/19
From: Christian Hesse <mail@earthworm.de>
To: suspend2-devel@lists.tuxonice.net, nigel@nigel.suspend2.net
Subject: Reboot problem (was: Re: [Suspend2-devel] What's in store for 2008 for TuxOnIce?)
Date: Wed, 2 Jan 2008 00:30:03 +0100
User-Agent: KMail/1.9.7
Cc: "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <477AC060.5040004@nigel.suspend2.net>
In-Reply-To: <477AC060.5040004@nigel.suspend2.net>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020030.06940.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 January 2008, Nigel Cunningham wrote:
> Third, regarding the patch itself, I'm taking my time in working towards
> the 3.0 release. We don't have any major bugs with 3.0-rc3 reported [...].

Well, I think I still have a bug, though it is possibly a mainline problem and 
it's not a showstopper. After a suspend/resume cycle the reboot does not 
work. The system hangs with "Rebooting system" (or similar). After that you 
have to hard reset the system, which is not really a problem as filesystems 
have been unmounted before. Reboot without a suspend cycle before and halt 
with and without suspend cycle work without problems.
I'm using toi 3.0-rc3 with kernel 2.6.24-rc6 and beside the problem described 
above I'm really happy with toi.

Happy new your to everybody!
-- 
Regards,
Chris
