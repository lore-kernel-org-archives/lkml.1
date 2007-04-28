Return-Path: <linux-kernel-owner+w=401wt.eu-S1163477AbXD1SZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163477AbXD1SZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163478AbXD1SZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:25:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:40197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163477AbXD1SYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:24:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Date: Sat, 28 Apr 2007 20:24:41 +0200
User-Agent: KMail/1.9.6
Cc: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20070428758.455116000@suse.de> <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
In-Reply-To: <46338D72.70402@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704282024.41575.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Can you point to / link to threads where the bootloader folks looked 
> over the reloc changes from their side, and commented?

What boot loader folks? The result still works with grub and pxelinux at least
and I guess the others will complain as they get around testing new kernels.

-Andi

