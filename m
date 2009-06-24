Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZFXDYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZFXDYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZFXDYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:24:24 -0400
Received: from ozlabs.org ([203.10.76.45]:51326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZFXDYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:24:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Wed, 24 Jun 2009 12:54:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
References: <20090623161416.072b43ba.sfr@canb.auug.org.au>
In-Reply-To: <20090623161416.072b43ba.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241254.24945.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 03:44:16 pm Stephen Rothwell wrote:
> Hi Rusty,
>
> Today's linux-next build (arm realview-smp_defconfig) failed like this:
>
> arch/arm/kernel/smp.c: In function 'flush_tlb_mm':
> arch/arm/kernel/smp.c:646: error: lvalue required as unary '&' operand
> arch/arm/kernel/smp.c: In function 'flush_tlb_page':
> arch/arm/kernel/smp.c:657: error: lvalue required as unary '&' operand
> arch/arm/kernel/smp.c: In function 'flush_tlb_range':
> arch/arm/kernel/smp.c:680: error: lvalue required as unary '&' operand

Dumb typo + cut & paste.

Fixed,
Rusty.

