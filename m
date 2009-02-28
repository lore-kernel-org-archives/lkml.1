Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZB1GXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZB1GXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZB1GXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:23:08 -0500
Received: from gw.goop.org ([64.81.55.164]:59710 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZB1GXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:23:07 -0500
Message-ID: <49A8D848.3000907@goop.org>
Date: Fri, 27 Feb 2009 22:23:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: bderzhavets@yahoo.com
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: core dom0 support
References: <185173.37814.qm@web56102.mail.re3.yahoo.com>
In-Reply-To: <185173.37814.qm@web56102.mail.re3.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Derzhavets wrote:
>  
> Does it mean that Wiki Page should  look now as ?
> ----------------------------------------------------------------------------------------------------------------------
> git   clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git   
> linux-2.6-xen
> cd   linux-2.6-xen
> git   checkout   origin/push/xen/dom0/core   -b    push/xen/dom0/core
>

No.  That branch is far from complete; the push/* branches are just for 
upstreaming things to the kernel, and are not independently useful.

xen/dom0/hackery continues to be the best place to get complete (as far 
as it goes) dom0 support.

    J
