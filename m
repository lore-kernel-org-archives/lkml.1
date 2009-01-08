Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbZAHOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbZAHOSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZAHOSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:18:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZAHOSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:18:07 -0500
Date: Thu, 8 Jan 2009 09:18:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
In-Reply-To: <20090107212912.e2903579.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901080917510.22642@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090107212912.e2903579.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Jan 2009, Andrew Morton wrote:

> On Wed, 7 Jan 2009 23:58:39 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  kernel/trace/ring_buffer.c |    8 +++++++-
> 
> <looks>
> 
> heavens, what a lot of inlining.  Looks like something from 1997 :)
> 
> Prove me wrong!

I'm working on it ;-)

-- Steve
