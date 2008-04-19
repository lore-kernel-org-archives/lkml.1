Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbYDSDiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbYDSDiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYDSDiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:38:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbYDSDiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:38:06 -0400
Date: Fri, 18 Apr 2008 20:32:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sandmann@redhat.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 4/5] ftrace: limit trace entries
Message-Id: <20080418203207.1c1024fa.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0804182311480.19025@gandalf.stny.rr.com>
References: <20080418200538.788522018@goodmis.org>
	<20080418200850.443055618@goodmis.org>
	<20080418131935.67daf8f0.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0804182311480.19025@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 23:12:43 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> Are you sure your name isn't Monk?

Nah, he'd have pointed out that it's "linked list", not "link list".

> New patch coming.

We could do this all day at this level of detail :)
