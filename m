Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbZBFBnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbZBFBnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZBFBnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:43:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZBFBnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:43:24 -0500
Date: Thu, 5 Feb 2009 23:43:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: remove unused flags parameter, fix
Message-ID: <20090206014308.GD9846@ghostprotocols.net>
References: <20090205181256.GH17653@ghostprotocols.net> <20090206000223.GB16040@elte.hu> <20090206001500.GA30095@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206001500.GA30095@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 06, 2009 at 01:15:00AM +0100, Ingo Molnar escreveu:
> 
> Small fixlet below, applied to tip:tracing/ftrace.
> 
> 	Ingo
> 
> --------------->
> >From 304cc6ae1bf7a8e6d00053fbe0b7e2b26cdddda2 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 6 Feb 2009 01:12:02 +0100
> Subject: [PATCH] ring_buffer: remove unused flags parameter, fix
> 
> Oprofile's ring-buffer use was not considered.

Thank you, adding oprofile to my kvm minimal config for tracing devel.

- Arnaldo
