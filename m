Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYBLTXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYBLTXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYBLTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:23:13 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:34981 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYBLTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:23:11 -0500
Date: Tue, 12 Feb 2008 14:22:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] add task migration_disable critical section
In-Reply-To: <20080212183000.10902.97544.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0802121420470.21926@gandalf.stny.rr.com>
References: <20080212182512.10902.66459.stgit@novell1.haskins.net>
 <20080212183000.10902.97544.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 Feb 2008, Gregory Haskins wrote:

> This patch adds a new critical-section primitive pair:
>
> "migration_disable()" and "migration_enable()"

This is similar to what Mathieu once posted:

http://lkml.org/lkml/2007/7/11/13

Not sure the arguments against (no time to read the thread again). But I'd
recommend that you read it.

-- Steve

