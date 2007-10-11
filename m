Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbXJKSdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbXJKSdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 14:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXJKScy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 14:32:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbXJKScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 14:32:53 -0400
Date: Thu, 11 Oct 2007 11:32:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] Linux Kernel Markers - Samples
Message-Id: <20071011113211.6ec9a8ee.akpm@linux-foundation.org>
In-Reply-To: <20071011132712.GA3580@Krystal>
References: <20070928142845.795281397@polymtl.ca>
	<20070928143159.948108939@polymtl.ca>
	<20071011021355.53302c04.akpm@linux-foundation.org>
	<20071011132712.GA3580@Krystal>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 09:27:12 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > samples/markers/marker-example.c: In function 'my_open':
> > samples/markers/marker-example.c:22: warning: asm operand 0 probably doesn't match constraints
> > samples/markers/marker-example.c:24: warning: asm operand 0 probably doesn't match constraints
> > samples/markers/marker-example.c:22: error: impossible constraint in 'asm'
> > samples/markers/marker-example.c:24: error: impossible constraint in 'asm'
> 
> Hrm, I have s390 gcc-4.1.1 here and cannot reproduce the problem with it.
> 
> What compiler are you using ?

4.1.0, from http://userweb.kernel.org/~akpm/cross-compilers/s390-cross.tar.gz
