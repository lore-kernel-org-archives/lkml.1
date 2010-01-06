Return-Path: <linux-kernel-owner+w=401wt.eu-S932636Ab0AFUwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0AFUwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295Ab0AFUv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:51:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab0AFUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:51:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/3] generic sys_ipc wrapper
Date: Wed, 6 Jan 2010 21:48:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
References: <20100106172152.GC17163@lst.de> <201001062052.11641.arnd@arndb.de> <20100106195905.GE1728@n2100.arm.linux.org.uk>
In-Reply-To: <20100106195905.GE1728@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001062148.44515.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/7Yww+cHSbWgMjeJVNCiJyFXgwFi9rs1xwtIL
 uKBUnMv/dtupYDvNOKusObizkF96vk3nUVz7YpJDVvZFiLCvBE
 x3NbRolbPBSur3a8hwWcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010 20:59:05 Russell King - ARM Linux wrote:
> > This would not build on any of the architecture mentioned, because of
> > incorrect placement of curly braces, but as Al mentioned it should just
> > go away entirely.
> 
> They look fine to me.

Ah, right. I just got confused.

	Arnd 
