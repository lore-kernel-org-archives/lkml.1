Return-Path: <linux-kernel-owner+w=401wt.eu-S936783AbZDCUeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936783AbZDCUeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936505AbZDCUeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:34:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936138AbZDCUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:34:20 -0400
Date: Fri, 3 Apr 2009 16:34:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Huang Weiyi <weiyi.huang@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing, x86: remove duplicated #include
In-Reply-To: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
Message-ID: <alpine.DEB.2.00.0904031634000.21481@gandalf.stny.rr.com>
References: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 31 Mar 2009, Huang Weiyi wrote:

> Remove duplicated #include in arch/x86/kernel/ftrace.c.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Thanks, applied.

-- Steve

