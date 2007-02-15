Return-Path: <linux-kernel-owner+w=401wt.eu-S964914AbXBOG5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914AbXBOG5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964920AbXBOG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:57:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964914AbXBOG5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:57:03 -0500
Date: Wed, 14 Feb 2007 22:56:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] local_t : powerpc extension
Message-Id: <20070214225653.345aad29.akpm@linux-foundation.org>
In-Reply-To: <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca>
	<11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007 14:18:12 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> local_t : powerpc extension

This diff contains changes which are also present in "[PATCH 07/10]
atomic.h : Add atomic64 cmpxchg, xchg and add_unless to powerpc", resulting
in rather a mess.

I dropped the duplicated hunks from the later patch rather than this one,
but I haven't tried to compile the result yet.

