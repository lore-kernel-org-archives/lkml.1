Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYHARFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYHARFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYHARF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:05:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYHARF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:05:26 -0400
Date: Fri, 1 Aug 2008 10:04:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: re-annotate scheduler runqueues
In-Reply-To: <1217588923.9686.7.camel@twins>
Message-ID: <alpine.LFD.1.10.0808011004000.3277@nehalem.linux-foundation.org>
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588923.9686.7.camel@twins>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo, I hope you haven't gone off for a vacation yet, because right now 
I'm not sure any of the scheduler trees are safe to pull. So pls advise.

		Linus
