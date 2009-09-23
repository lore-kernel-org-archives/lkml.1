Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZIWAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZIWAk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZIWAk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:40:26 -0400
Received: from fifo99.com ([67.223.236.141]:33259 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZIWAkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:40:25 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <20090922180611.7a47adcc@tpl.lwn.net>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net>
	 <1253663739.4317.12.camel@desktop>  <20090922180611.7a47adcc@tpl.lwn.net>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 17:40:23 -0700
Message-Id: <1253666423.25689.30.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 18:06 -0600, Jonathan Corbet wrote:
> On Tue, 22 Sep 2009 16:55:39 -0700
> Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > We did .. It's not my mailer, it's my scripts .. I read a little of
> > wikipedia on this and it says it's a MIME encoding..
> > 
> > http://en.wikipedia.org/wiki/Quoted-printable
> > 
> > So it's like a mime encoded patch instead of plain ascii encoded
> > patch .. I don't think we should all have to parse this stuff out, we
> > should just be getting utf8 encodings which covers everything we use in
> > the kernel AFAIK ..
> 
> I have scripts that handle email as well.  But I wrote them in a
> scripting language which has modules to cope with standard-compliant
> email, and I have no trouble with other transfer encodings at all.  You
> really need to do the same.  Better you fix your scripts than
> continually demanding that the rest of the development community
> conform to your restrictive requirements.

"restrictive requirements" ? I mean don't blame me for that .. It's in
Documentation/email-clients.txt .. The selected norm is UTF8 , and I
don't disagree with that. After researching it that is what we should be
using. At the same time, I'm not demanding anything of anyone , I'm
simply asking nicely for the submitter to check what they are doing..

My scripts may not handle it which is fine. I just wouldn't likely end
up reviewing it. That really isn't bad for _me_ ..

> Daniel, I believe that you are really trying to help make the kernel
> better.  But I fear that you may be having the opposite effect by
> discouraging contributions from others.  Please consider taking a step
> back and thinking about your interactions and the nature of your
> efforts; I think you may find that there are more productive and
> encouraging ways for you to contribute.

I am trying to make the kernel (or community) better, but my motivation
is purely my own (as it often is with people on this list) ..

I don't see the effects your indicating, discouraging contributions .. I
think if anything I'm helping people to get to a place where they can
contribute in a comfortable way without worrying about things like
checkpatch .. I think the problem most submitters have on this list is
that no one tells them they are doing something wrong so they don't
correct it. I clearly recall submitting my first several patches
copy-and-pasted which got either ignored , or caused a maintainer lots
of pain .. Had I been told earlier that it was a problem I would have
corrected it immediately (and been happy to have been notified about
it)..

discouraging contributions is more something that happens when you get
the responses I got earlier in this thread..

Daniel

