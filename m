Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYL2Mnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYL2Mnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYL2Mns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:43:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYL2Mnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:43:47 -0500
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
In-Reply-To: <20081229122251.GA13687@elte.hu>
References: <1230382948.3373.1.camel@jaswinder.satnam>
	 <20081229121218.GB9628@elte.hu>  <20081229122251.GA13687@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 18:11:50 +0530
Message-Id: <1230554510.3990.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Mon, 2008-12-29 at 13:22 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> btw., you missed to update a couple of places - pci/pci.h was used outside 
> of arch/x86 as well. Updated patch below.
> 

Ahh, I will be more careful next time.

Thanks for your kindness :-)

	JSR

