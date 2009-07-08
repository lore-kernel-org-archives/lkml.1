Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZGHM2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZGHM2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZGHM2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:28:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:33993 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751123AbZGHM2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:28:16 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+Xt5A91ZyXC6Wv3ZTut4NAnCkg1HJW3oQjHymI3Z
	KL7uA5pav/BgJA
Date: Wed, 8 Jul 2009 14:28:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel@avr32linux.org
Subject: Re: [BUG 2.6.30] Bad page map in process
In-Reply-To: <20090708132308.12b25ac9@hcegtvedt.norway.atmel.com>
Message-ID: <Pine.LNX.4.64.0907081326000.15633@axis700.grange>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
 <20090708132308.12b25ac9@hcegtvedt.norway.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Hans-Christian Egtvedt wrote:

> On Wed, 8 Jul 2009 13:07:31 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> Hi Guennadi,
> 
> > with a 2.6.30 kernel 
> >
> 
> Could you give a short description of the rest of your setup as well?

Sure, it is based on buildroot v2.3.0:

> libc library and version number? Latest known to be good is uClibc
> v0.9.30.1.

It's v0.9.30.

> binutils version? Latest known to be good is binutils version
> 2.18.atmel.1.0.1.buildroot.1.

Yep.

> gcc version? Latest known to be good is gcc version
> 4.2.2-atmel.1.1.3.buildroot.1.

Yep.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
