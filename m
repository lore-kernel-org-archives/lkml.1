Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZKCPc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZKCPc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZKCPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:32:26 -0500
Received: from www.tglx.de ([62.245.132.106]:55004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZKCPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:32:25 -0500
Date: Tue, 3 Nov 2009 16:29:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code
 generic v2
In-Reply-To: <63386a3d0911030551j1accd6fby7038895df544385b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0911031628480.12138@localhost.localdomain>
References: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>  <63386a3d0910251518i42149642g183f2d3f6c43384f@mail.gmail.com> <63386a3d0911030551j1accd6fby7038895df544385b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Linus Walleij wrote:
> > Ping on tglx on this, I will uninline the functions if you think
> > it's better in the long run, just tell me, else can you pick this
> > patch?
> 
> Ping again...

Still catching up with mail backlog. Will come to this in the next
days.

      tglx
