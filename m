Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZG2O3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZG2O3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZG2O3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:29:41 -0400
Received: from leia.mcbone.net ([194.97.104.42]:42469 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZG2O3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:29:41 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Jens Rosenboom <jens@mcbone.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4A702AC2.2060003@gmail.com>
References: <1248681637.7279.12.camel@fnki-nb00130>
	 <1248694266.6987.1594.camel@twins> <1248697004.7279.31.camel@fnki-nb00130>
	 <1248697409.6987.1617.camel@twins> <1248698755.7279.47.camel@fnki-nb00130>
	 <1248701812.6987.1637.camel@twins> <1248848568.6757.13.camel@fnki-nb00130>
	 <1248861443.6757.20.camel@fnki-nb00130> <4A7023BC.6000109@cosmosbay.com>
	 <4A702AC2.2060003@gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:29:27 +0200
Message-Id: <1248877767.6757.23.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 12:56 +0200, Eric Dumazet wrote:
[...]
> Could you please try following patch ?
> 
> [PATCH] exec: must clear clear_child_tid
[...]

Running fine for three hours now, but I'll keep it running at least
until tomorrow to be sure.

