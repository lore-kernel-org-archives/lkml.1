Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZINN7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZINN7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZINN7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:59:08 -0400
Received: from fifo99.com ([67.223.236.141]:54401 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbZINN7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:59:08 -0400
Subject: Re: [RFC PATCH 0/2] tracing - signal tracer, support multiple pids
 in set_pid_ftrace
From: Daniel Walker <dwalker@fifo99.com>
To: jolsa@redhat.com
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
References: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 06:59:55 -0700
Message-Id: <1252936795.28368.217.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 12:14 +0200, jolsa@redhat.com wrote:
> 1/2 - signal trace
> 2/2 - multiple pids support for set_pid_ftrace file


The whole series several checkpatch errors. Could you fix those before
you take the RFC off this?

Daniel

