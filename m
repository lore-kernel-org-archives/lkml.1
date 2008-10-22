Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYJVTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYJVTMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbYJVTME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:12:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbYJVTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:12:02 -0400
Date: Wed, 22 Oct 2008 12:11:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 05/11] ftrace: only have ftrace_kill atomic
Message-Id: <20081022121128.5acc9ae0.akpm@linux-foundation.org>
In-Reply-To: <20081022185136.312667539@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
	<20081022185136.312667539@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 14:43:18 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Only have a way to completely disable ftrace in atomic sections.
> 

I have NFI what that means.

More importantly there is no explanation for *why* this change is being
made.


