Return-Path: <linux-kernel-owner+w=401wt.eu-S934417AbXEVQPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417AbXEVQPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXEVQO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:14:59 -0400
Received: from [81.2.110.250] ([81.2.110.250]:36753 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756617AbXEVQO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:14:58 -0400
Date: Tue, 22 May 2007 17:19:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Message-ID: <20070522171929.579c95c9@the-village.bc.nu>
In-Reply-To: <9e4733910705220906l323f3b9dw5204e7db700b30a6@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	<9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	<200705210914.22663.jbarnes@virtuousgeek.org>
	<200705210934.58559.jbarnes@virtuousgeek.org>
	<9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	<21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	<4652295E.7060305@garzik.org>
	<21d7e9970705220107mc096135nc26af32830d83646@mail.gmail.com>
	<4652A6F9.1040502@garzik.org>
	<9e4733910705220906l323f3b9dw5204e7db700b30a6@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 12:06:11 -0400
"Jon Smirl" <jonsmirl@gmail.com> wrote:

> Someone just pinged me privately asking about virtualization support
> for the console and graphics hardware. What's the plan for handling
> virtualization?

qemu already emulates a fairly crappy PCI video card. Since X supports
remote display properly thats sufficient for most things.

Alan
