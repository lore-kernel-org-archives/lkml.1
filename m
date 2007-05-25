Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbXEYHkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbXEYHkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXEYHj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:39:56 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:62152 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbXEYHjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:39:55 -0400
Subject: Re: [patch] sched_clock(): cleanups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com>
References: <20070525071005.GA6431@elte.hu>
	 <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
	 <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu>
	 <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 09:39:33 +0200
Message-Id: <1180078773.7348.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 13:05 +0530, Satyam Sharma wrote:
> On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:

> > call_r_s_f() still needs an urgent rerenaming though =B-)
> 
> So does "call_r_s_f_here()" :-)

That name makes me think of INTERCAL's 'DO COME FROM' statement.
And any code that makes one think of INTERCAL is say,.. special.. :-)

