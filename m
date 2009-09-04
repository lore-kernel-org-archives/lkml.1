Return-Path: <linux-kernel-owner+w=401wt.eu-S934379AbZIDWRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbZIDWRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934350AbZIDWRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49352 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934324AbZIDWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:17:14 -0400
Subject: Re: [PATCH 0/2] tracing: Fixes for 2.6.32
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
In-Reply-To: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
References: <1252100537-7783-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 04 Sep 2009 18:17:14 -0400
Message-Id: <1252102634.21544.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 23:42 +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull these two tracing fixes which can be found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	tracing/core
> 

Frederic,

Thanks for handling this for me. I'm hoping to get my series of patches
to fix the latency tracer / events bug tonight.

Although it is already in git (and I hate that it can't add acks)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

For both patches.

-- Steve


