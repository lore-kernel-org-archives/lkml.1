Return-Path: <linux-kernel-owner+w=401wt.eu-S1033682AbXEIDeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033682AbXEIDeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969126AbXEIDeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:34:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36439 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967303AbXEIDeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:34:09 -0400
Date: Wed, 9 May 2007 09:03:48 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: yhlu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Message-ID: <20070509033348.GA12361@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org> <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com> <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com> <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com> <m1sla7i68s.fsf@ebiederm.dsl.xmission.com> <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com> <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:51:35AM -0700, yhlu wrote:
> Eric,
> 
> i tried to load vmlinux with kexec and got
> Ramdisks not supported with generic elf arguments
> 

This message generally appears if you did not specify --args-linux
on kexec command line while loading vmlinux.

Thanks
Vivek
