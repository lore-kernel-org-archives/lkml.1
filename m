Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZGXAh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZGXAh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZGXAh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:37:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZGXAh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:37:58 -0400
Date: Thu, 23 Jul 2009 20:37:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2] function-graph: use ftrace_graph_funcs
 directly
In-Reply-To: <4A66D01E.2000600@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907232037370.8469@gandalf.stny.rr.com>
References: <4A66D004.7020205@cn.fujitsu.com> <4A66D01E.2000600@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Li Zefan wrote:

> No need to store ftrace_graph_funcs in file->private.

Thanks, I'll queue this up for 32.

-- Steve

