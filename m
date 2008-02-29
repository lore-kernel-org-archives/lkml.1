Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbYB2Rn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbYB2Rn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYB2Rnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:43:43 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53164 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757533AbYB2Rnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:43:42 -0500
Date: Fri, 29 Feb 2008 18:42:22 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080229184222.2795f8d4@siona>
In-Reply-To: <20080228174349.1da254bd.akpm@linux-foundation.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
	<20080228071822.GA13571@elte.hu>
	<20080229003954.GA525@parisc-linux.org>
	<20080228174349.1da254bd.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 17:43:49 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> The only major conflict is with avr32 which seems to have just done a major
> revamp of that architecture's semaphore implementation.  Oh well.

Not anymore. It was a pure spaces-to-tabs conversion, so I dropped it.

Haavard
