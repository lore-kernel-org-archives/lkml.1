Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZIWAFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZIWAFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZIWAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:05:51 -0400
Received: from vena.lwn.net ([206.168.112.25]:33180 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZIWAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:05:50 -0400
Date: Tue, 22 Sep 2009 18:06:11 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
Message-ID: <20090922180611.7a47adcc@tpl.lwn.net>
In-Reply-To: <1253663739.4317.12.camel@desktop>
References: <1253615424.20345.76.camel@Palantir>
	<1253625878.6575.34.camel@desktop>
	<20090922173916.257dff1d@tpl.lwn.net>
	<1253663739.4317.12.camel@desktop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 16:55:39 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> We did .. It's not my mailer, it's my scripts .. I read a little of
> wikipedia on this and it says it's a MIME encoding..
> 
> http://en.wikipedia.org/wiki/Quoted-printable
> 
> So it's like a mime encoded patch instead of plain ascii encoded
> patch .. I don't think we should all have to parse this stuff out, we
> should just be getting utf8 encodings which covers everything we use in
> the kernel AFAIK ..

I have scripts that handle email as well.  But I wrote them in a
scripting language which has modules to cope with standard-compliant
email, and I have no trouble with other transfer encodings at all.  You
really need to do the same.  Better you fix your scripts than
continually demanding that the rest of the development community
conform to your restrictive requirements.

Daniel, I believe that you are really trying to help make the kernel
better.  But I fear that you may be having the opposite effect by
discouraging contributions from others.  Please consider taking a step
back and thinking about your interactions and the nature of your
efforts; I think you may find that there are more productive and
encouraging ways for you to contribute.

Thanks,

jon
