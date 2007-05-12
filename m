Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbXELGT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbXELGT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXELGTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:19:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbXELGTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:19:52 -0400
Date: Fri, 11 May 2007 23:19:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: FUTEX_CMP_REQUEUE_PI is not quite there
Message-Id: <20070511231931.52d963ab.akpm@linux-foundation.org>
In-Reply-To: <46455A67.8040203@redhat.com>
References: <46455A67.8040203@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 23:10:47 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> I hooked up FUTEX_CMP_REQUEUE_PI here and got a kernel crash.

Well yup.  We're kind of waiting for someone to reply
to http://lkml.org/lkml/2007/5/7/129
