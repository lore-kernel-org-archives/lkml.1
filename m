Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbXLNJmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbXLNJmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXLNJmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:42:17 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64404 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762AbXLNJmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:42:16 -0500
Date: Fri, 14 Dec 2007 10:41:58 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Working upstream toolchain for avr32?
Message-ID: <20071214104158.6d256b7b@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20071213195617.GF21616@stusta.de>
References: <20071213195617.GF21616@stusta.de>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 20:56:17 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> AFAIK the latest available AVR32 toolchains are some patched gcc 4.0 and 
> some patched binutils 2.17, and avr32 is currently the only architecture 
> in the kernel where upstream of both of them is not capable of building 
> a kernel for the architecture.

gcc 4.2 is available from www.atmel.com. But I agree that it's
unfortunate that avr32 support isn't available upstream.

> ALthough not technically a requirement, it would be nice if all Linux 
> kernel archs could be compiled with plain upstream toolchains.

We're working on it. I believe the legal issues around copyright
assignment, etc. are mostly sorted out now, so I'm hoping we'll start
pushing things upstream early next year.

> Even more since at some point in the future [1] current toolchains might 
> no longer be able to compile the then current kernels.

I'm not sure if I understood that, but I guess it's always good to have
older versions of the toolchain around.

Haavard
