Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGaPau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGaPau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYGaPan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:30:43 -0400
Received: from vena.lwn.net ([206.168.112.25]:42979 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYGaPam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:30:42 -0400
Date: Thu, 31 Jul 2008 09:30:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org, greg@kroah.com,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH stable] ftrace document crucial update
Message-ID: <20080731093039.4afcb734@bike.lwn.net>
In-Reply-To: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 23:05:02 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> Never mind that ftrace itself doesn't exist is 2.6.26.

I just figured you were trying to raise the bar by showing that it's
possible to get the documentation in before the code...

>  Copyright 2008 Red Hat Inc.
> -Author: Steven Rostedt <srostedt@redhat.com>
> +   Author:   Steven Rostedt <srostedt@redhat.com>
> +  License:   The GNU Free Documentation License, Version 1.2

Is FDL appropriate for stuff shipped with the kernel?  I would suspect
it would at least need a GPL-compatible dual-license option.

jon
