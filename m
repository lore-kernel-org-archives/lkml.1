Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbYHRKAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbYHRKAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYHRKAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:00:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:36839 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHRKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:00:46 -0400
Subject: Re: RT-Preemption is causing Very-High Interrupt Latency
From: Peter Zijlstra <peterz@infradead.org>
To: p_ashish <priyadarshi.ashish@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <19026358.post@talk.nabble.com>
References: <19026358.post@talk.nabble.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:00:58 +0200
Message-Id: <1219053658.10800.287.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-17 at 23:02 -0700, p_ashish wrote:
> I applied RT-preemption and High-Resolution Timer Patch to linux-2.6.19.2 

That is a very ancient kernel - please try .26-rt (or .24-rt which is
atm a little more stable).

