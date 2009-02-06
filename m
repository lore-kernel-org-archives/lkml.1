Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZBFBzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZBFBzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBFBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:55:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBFBza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:55:30 -0500
Date: Thu, 5 Feb 2009 23:55:11 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] trace: Call tracing_reset_online_cpus before
	tracer->init()
Message-ID: <20090206015511.GG9846@ghostprotocols.net>
References: <20090205200200.GB9846@ghostprotocols.net> <20090205231236.GC23999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205231236.GC23999@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 06, 2009 at 12:12:37AM +0100, Frederic Weisbecker escreveu:
> 
> Heh, I will have to manage an "arnaldo" topic in my local git tree
> if I want to stay synced :-)
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Hey, don't tease me ;-)

- Arnaldo
