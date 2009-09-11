Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZIKPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZIKPch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIKPcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:32:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZIKPcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:32:36 -0400
Subject: Re: [PATCHv3 0/3] tracing - adding common method for
 reading/parsing user input
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
References: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 11:32:38 -0400
Message-Id: <1252683158.18996.698.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 17:29 +0200, jolsa@redhat.com wrote:
> As 3 different places for 4 user input files were using the same way
> of reading and parsing user's input, I made one common routine to be
> used. 
> 
> The mentioned files are:
> 	set_graph_function
> 	set_event
> 	set_ftrace_filter
> 	set_ftrace_notrace
> 
> wbr,
> jirka

Thanks Jirka, much better.

I'll pull them in and try them out.

-- Steve


