Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYKLGB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYKLGB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYKLGBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:01:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYKLGBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:01:20 -0500
Date: Tue, 11 Nov 2008 22:00:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for
 initcall entries
Message-Id: <20081111220051.204c43f2.akpm@linux-foundation.org>
In-Reply-To: <20081112055600.657041406@goodmis.org>
References: <20081112055454.798779203@goodmis.org>
	<20081112055600.657041406@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 00:54:56 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> -	unsigned long long	duration;		/* usecs */
> +	unsigned long long 	duration;

my hard-won comment got fragged.
