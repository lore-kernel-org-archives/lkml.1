Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXJKJOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXJKJOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXJKJOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:14:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbXJKJOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:14:35 -0400
Date: Thu, 11 Oct 2007 02:13:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] Linux Kernel Markers - Samples
Message-Id: <20071011021355.53302c04.akpm@linux-foundation.org>
In-Reply-To: <20070928143159.948108939@polymtl.ca>
References: <20070928142845.795281397@polymtl.ca>
	<20070928143159.948108939@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:28:49 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Module example showing how to use the Linux Kernel Markers.

s390:

samples/markers/marker-example.c: In function 'my_open':
samples/markers/marker-example.c:22: warning: asm operand 0 probably doesn't match constraints
samples/markers/marker-example.c:24: warning: asm operand 0 probably doesn't match constraints
samples/markers/marker-example.c:22: error: impossible constraint in 'asm'
samples/markers/marker-example.c:24: error: impossible constraint in 'asm'
