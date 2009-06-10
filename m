Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbZFJRD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbZFJRD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761060AbZFJRC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:02:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbZFJRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:02:57 -0400
Date: Wed, 10 Jun 2009 13:02:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace.txt: fix typo in function grapher name
In-Reply-To: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.00.0906101302470.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Mike Frysinger wrote:

> The function graph tracer is called just "function_graph" (no trailing
> "_tracer" needed).
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, I'll queue it up.

-- Steve

> ---
>  Documentation/trace/ftrace.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index fd9a3e6..5ad2ded 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -179,7 +179,7 @@ Here is the list of current tracers that may be configured.
>  
>  	Function call tracer to trace all kernel functions.
>  
> -  "function_graph_tracer"
> +  "function_graph"
>  
>  	Similar to the function tracer except that the
>  	function tracer probes the functions on their entry
> -- 
> 1.6.3.1
> 
> 
