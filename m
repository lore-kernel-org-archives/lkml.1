Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYLVWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYLVWoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYLVWn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:43:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbYLVWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:43:57 -0500
Date: Mon, 22 Dec 2008 14:43:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [patch] powerpc: change u64/s64 to a long long integer type
Message-Id: <20081222144319.1bfc0061.akpm@linux-foundation.org>
In-Reply-To: <20081222080341.GA18897@elte.hu>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au>
	<b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com>
	<20081222070426.GD29160@elte.hu>
	<20081222181932.5dd9514e.sfr@canb.auug.org.au>
	<20081222080341.GA18897@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008 09:03:41 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Subject: powerpc: change u64/s64 to a long long integer type

<applause>

There are lots of other architctures that need doing though.
