Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYKZFjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYKZFjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYKZFje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:39:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYKZFjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:39:33 -0500
Date: Tue, 25 Nov 2008 21:39:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace: add cpu annotation for function graph
 tracer
Message-Id: <20081125213909.d4eb3f09.akpm@linux-foundation.org>
In-Reply-To: <20081126051710.339437727@goodmis.org>
References: <20081126051622.134970943@goodmis.org>
	<20081126051710.339437727@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 00:16:27 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds the annotation of 'CPU[###]' where ### is a three digit
> number

Is this a plot to get yourself sent a 1024-way test box?
