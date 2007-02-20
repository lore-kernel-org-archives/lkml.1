Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXBTLkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXBTLkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932902AbXBTLkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:40:55 -0500
Received: from smtp.nokia.com ([131.228.20.172]:51171 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbXBTLky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:40:54 -0500
Subject: Re: [PATCH 12/44 take 2] [UBI] allocation unit implementation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <84144f020702190313m38b670eew204a5017e777851e@mail.gmail.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
	 <84144f020702190313m38b670eew204a5017e777851e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 13:30:59 +0200
Message-Id: <1171971059.4039.0.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 11:30:59.0843 (UTC) FILETIME=[98557D30:01C754E2]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220132817-53B56BB0-690F03A5/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 13:13 +0200, Pekka Enberg wrote:
> NAK. Please drop all of these utterly pointless kmalloc() and
> kmem_cache_alloc() wrappers.

Will be fixed.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

