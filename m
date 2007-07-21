Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXGUVSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXGUVSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXGUVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:17:59 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:7415 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbXGUVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HL05tAADDbTmrEpj1c+Fbm00rq/cinNuPMNOogRiQdgNj4n8VW6CjoMzwQz9O55WgU2spZPkbbTeZ5VVbX3Qgodnd5SKbXWIXRCHyqLdjN3upMWz4pN+8HzEbytbJILB6L3ng9gpEaK5zq5ep637WJLa8ormOes+Z/imQTmVOBQ=
Message-ID: <4409201d0707211417x476ffc5buba0e5cab97913a84@mail.gmail.com>
Date: Sat, 21 Jul 2007 23:17:56 +0200
From: ". ." <kerdezdmeg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <4409201d0707211408y4d3d9cd1g73e1c0925ecad5f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4409201d0707211408y4d3d9cd1g73e1c0925ecad5f9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: . . <kerdezdmeg@gmail.com>
Date: Jul 21, 2007 11:08 PM
Subject: [RFC, Announce] Unified x86 architecture, arch/x86
To: tglx@linutronix.de
Cc: torvalds@osdl.org, akpm@osdl.org, ak@suse.de, mingo@elte.hu,
arjan@infradead.org, chrisw@sous-sol.org

Hi all!

[please CC me]

I think, for this time is te good, for starting the 2.7-tree. I know,
thet is the old question, but has everything in his favour:
 * arch unifie (i386 + x86_84 -> x86)
 * new virtualisation technik (xen, kvm, lguest)
 * new FS (ext4, reiser4)
 * new cpu-scheduler (CFS)
 * soo many patch in -mm tree
 * subsystem modifications

thanks
Oliver
