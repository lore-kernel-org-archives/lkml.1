Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZCHKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZCHKrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZCHKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:47:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZCHKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:47:02 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236508753.3638.3.camel@localhost.localdomain>
References: <1236507232.28127.2.camel@localhost.localdomain>
	 <1236507643.22914.3642.camel@twins>
	 <1236508753.3638.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 11:46:50 +0100
Message-Id: <1236509210.6376.1600.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 16:09 +0530, Jaswinder Singh Rajput wrote:
> These leads to warnings:
>  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Its the exception that makes the rule ;-)



