Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYDXOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYDXOG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYDXOGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:06:37 -0400
Received: from kolab.mylinuxtime.de ([212.112.242.22]:59926 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYDXOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:06:36 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 10:06:36 EDT
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: A system for rebootless kernel security updates
Date: Thu, 24 Apr 2008 15:43:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241543.06874.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Jeff Arnold wrote:
> Hello,
>
> I've put together an automatic system for applying kernel security patches
> to the Linux kernel without rebooting it, and I wanted to share this
> system with the community in case others find it useful or interesting.

This sounds really interesting. I just wanted to test on my Gentoo system with 
kernel 2.6.25. The tarball creation works, but applying the change brings an 
error to syslog:

ksplice_242e9pfc_helper: Unknown symbol init_mm

Any chance to get a fix for that?
-- 
Regards,
Chris
