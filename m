Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZINOFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZINOFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZINOFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZINOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:05:42 -0400
Date: Mon, 14 Sep 2009 16:05:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] tracing - signal tracer, support multiple pids
	in set_pid_ftrace
Message-ID: <20090914140530.GA22007@jolsa.redhat.com>
References: <1252923251-6735-1-git-send-email-jolsa@redhat.com> <1252936795.28368.217.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252936795.28368.217.camel@desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 06:59:55AM -0700, Daniel Walker wrote:
> On Mon, 2009-09-14 at 12:14 +0200, jolsa@redhat.com wrote:
> > 1/2 - signal trace
> > 2/2 - multiple pids support for set_pid_ftrace file
> 
> 
> The whole series several checkpatch errors. Could you fix those before
> you take the RFC off this?
> 
> Daniel
> 
yes, I know about them
I'll fix them for the final version

wbr,
jirka
