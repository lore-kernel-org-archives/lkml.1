Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZJVMvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZJVMvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZJVMvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:51:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbZJVMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:51:20 -0400
Subject: Re: [PATCH 2/4] tracing: fix trace_seq_printf return value
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091022120958.GB2311@jolsa.redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
	 <1256135801-1849-3-git-send-email-jolsa@redhat.com>
	 <1256142035.18347.3133.camel@gandalf.stny.rr.com>
	 <20091021220204.GA2462@jolsa.redhat.com>
	 <1256163247.18347.3544.camel@gandalf.stny.rr.com>
	 <20091022120958.GB2311@jolsa.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 22 Oct 2009 08:51:22 -0400
Message-Id: <1256215882.20866.552.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 14:09 +0200, Jiri Olsa wrote:

> > err, I hate to remove that function. This is a utility file that is
> > exported for other parts of the kernel to use. At least make that a
> > separate patch.
> np, sending out just the first part

Thanks, I'll pull you patches in today and queue them up for 2.6.33.

-- Steve


