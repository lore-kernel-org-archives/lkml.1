Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYGHF2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYGHF2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYGHF20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:28:26 -0400
Received: from gw.goop.org ([64.81.55.164]:33655 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYGHF2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:28:25 -0400
Message-ID: <4872FAEF.9070508@goop.org>
Date: Mon, 07 Jul 2008 22:28:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
       Xen devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Friebel <thomas.friebel@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
References: <20080707190749.299430659@goop.org> <200807081029.19242.rusty@rustcorp.com.au> <200807081451.43433.nickpiggin@yahoo.com.au>
In-Reply-To: <200807081451.43433.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> What's lguest's solution?
>   

Uniprocessor only.

    J
