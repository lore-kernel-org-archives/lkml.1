Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbZG3ONx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbZG3ONx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZG3ONw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:13:52 -0400
Received: from leia.mcbone.net ([194.97.104.42]:57704 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZG3ONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:13:52 -0400
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
Date: Thu, 30 Jul 2009 16:13:34 +0200
Message-Id: <1248963214.6757.32.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another 24 hours without stuck processes have earned you my

Tested-by: Jens Rosenboom <jens@mcbone.net>

