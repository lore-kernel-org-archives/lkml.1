Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYGGGql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYGGGql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGGGqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:46:32 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59016 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbYGGGqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:46:32 -0400
To: a.p.zijlstra@chello.nl
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] fix task dirty balancing
In-Reply-To: Your message of "Sat, 05 Jul 2008 11:30:02 +0200"
	<1215250202.6320.10.camel@lappy.programming.kicks-ass.net>
References: <1215250202.6320.10.camel@lappy.programming.kicks-ass.net>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080707064631.1C6975A19@siro.lan>
Date: Mon,  7 Jul 2008 15:46:31 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, why was the EXPORT added anyway - fs/buffers.o never ends up in
> modules?

are you talking about EXPORT_SYMBOL_GPL in my patch?
well, actually, i don't know. :)  it might be unnecessary.

YAMAMOTO Takashi
