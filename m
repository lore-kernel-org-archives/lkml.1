Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZGVEWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZGVEWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 00:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZGVEWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 00:22:23 -0400
Received: from ozlabs.org ([203.10.76.45]:46523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZGVEWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 00:22:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] tracing/events: Add module tracepoints
Date: Wed, 22 Jul 2009 13:52:17 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <4A6582C1.2040609@cn.fujitsu.com>
In-Reply-To: <4A6582C1.2040609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221352.17850.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 06:26:33 pm Li Zefan wrote:
> Add trace points to trace module_load, module_free, module_get,
> module_put and module_request, and use trace_event facility
> to get the trace output.

Hi Li Zefan,

   I don't know anything about tracing, but the module code changes look
simple and fine to me.

Thanks,
Rusty.
