Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYJ3OtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYJ3OtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYJ3OtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:49:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYJ3Os7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:48:59 -0400
Date: Thu, 30 Oct 2008 12:47:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints 2.6.27.4
	backport
Message-ID: <20081030144754.GD25056@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030144437.GA13812@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030144437.GA13812@Krystal>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2008 at 10:44:37AM -0400, Mathieu Desnoyers escreveu:
> Hi Arnaldo,
> 
> I've backported it to 2.6.27.4 so I can merge it in my current -lttng
> tree.  (I'll move to 2.6.28-rc soon though). I send it here for future
> reference.

Cool, Jens already has it on:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=for-2.6.29

And also on the branches "for-akpm" and "for-next".

- Arnaldo
