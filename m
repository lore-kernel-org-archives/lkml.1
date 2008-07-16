Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYGPHxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYGPHxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGPHx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:53:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42893 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYGPHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:53:26 -0400
Date: Wed, 16 Jul 2008 09:53:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <20080715204320.GJ24533@cs181140183.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0807160951000.26724@fbirervta.pbzchgretzou.qr>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
 <20080715204320.GJ24533@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-15 22:43, Adrian Bunk wrote:
>
>The 2.6. prefix is like with X which is version 11 for 20 years and 
>still counting.
>
>Or like with X11R6, that became X11R7 after 11 years, there might be
>in a few years some big change that will warrant a 2.8 or 3.0 (the
>rewrite of the kernel in Visual Basic .NET ;-) ).

Jumping the major number would really require some big flag day.
What was it that made the jump from 1.x to 2.0?
(Some ABI change w.r.t. binaries -- ELF becoming standard maybe?)
