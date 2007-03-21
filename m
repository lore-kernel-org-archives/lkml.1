Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXCUQT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXCUQT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXCUQT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:19:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46205 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbXCUQT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:19:58 -0400
To: andi@firstfloor.org
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <20070321160929.GB25583@one.firstfloor.org>
Message-ID: <Vmgv8b38.1174493996.6673440.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Christoph Lameter" <christoph@lameter.com>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Wed, 21 Mar 2007 18:19:56 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/21/2007, "Andi Kleen" <andi@firstfloor.org> wrote:
> You can always use numa emulation on x86-64.  Boot with 
> numa=fake=NODES

Yes, I know, but I don't have a x86-64 box either =)
