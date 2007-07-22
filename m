Return-Path: <linux-kernel-owner+w=401wt.eu-S1764693AbXGVUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764693AbXGVUfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762782AbXGVUfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:35:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50288 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762779AbXGVUfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:35:23 -0400
Date: Sun, 22 Jul 2007 22:35:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
In-Reply-To: <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707222235130.32367@fbirervta.pbzchgretzou.qr>
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
 <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 22:16, Oliver Pinter wrote:
> Hi all!
>
> Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
> for help, because number of person has the question: I have Pentium D,
> and which CPU chose  I.
>
> arch/i386/Kconfig.cpu |   18 +++++++++---------
> 1 files changed, 9 insertions(+), 9 deletions(-)

But why move the config entry?



	Jan
-- 
