Return-Path: <linux-kernel-owner+w=401wt.eu-S1030796AbXDKENh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796AbXDKENh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030797AbXDKENh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:13:37 -0400
Received: from ozlabs.org ([203.10.76.45]:46908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030796AbXDKENg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:13:36 -0400
Subject: Re: [PATCH] Clean up x86 control register and MSR macros
	(corrected)
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200704101736.l3AHaiUv027830@tazenda.hos.anvin.org>
References: <200704101736.l3AHaiUv027830@tazenda.hos.anvin.org>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 14:13:34 +1000
Message-Id: <1176264814.26372.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 10:36 -0700, H. Peter Anvin wrote:
> This patch is based on Rusty's recent cleanup of the EFLAGS-related
> macros; it extends the same kind of cleanup to control registers and
> MSRs.

Thanks hpa, this looks nice.

Cheers,
Rusty.


