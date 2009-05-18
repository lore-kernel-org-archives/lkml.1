Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZERQXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZERQXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZERQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:23:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZERQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:23:03 -0400
Date: Mon, 18 May 2009 12:23:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Smith <dsmith@redhat.com>
cc: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [tracing] ring_buffer question
In-Reply-To: <4A1185B9.8050301@redhat.com>
Message-ID: <alpine.DEB.2.00.0905181222410.21785@gandalf.stny.rr.com>
References: <1242594505.6327.3.camel@localhost.localdomain> <1242607182.6327.8.camel@localhost.localdomain> <4A1185B9.8050301@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 May 2009, David Smith wrote:

> Jon Masters wrote:
> > [thinking out loud] Does the global disable stuff also disable other
> > non-tracing ring buffers?
> 
> I believe it does.  If I'm correct, I think it would be a good idea to
> make that an ftrace-disable feature, not a general ring buffer disable
> feature.

We can do that when we get more users of the ring buffer and we find it 
makes sense.

-- Steve

