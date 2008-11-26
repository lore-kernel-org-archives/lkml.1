Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYKZOsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYKZOsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYKZOsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:48:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:60927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYKZOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:48:20 -0500
Date: Wed, 26 Nov 2008 06:49:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
 oops dumps
Message-ID: <20081126064916.12738450@infradead.org>
In-Reply-To: <19f34abd0811260018l6886ee07m7d39cb84a7138929@mail.gmail.com>
References: <20081123130042.1d194768@infradead.org>
	<19f34abd0811260018l6886ee07m7d39cb84a7138929@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 09:18:46 +0100
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Sun, Nov 23, 2008 at 10:00 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > From 57b0deb1ad706a94e3118baee4127676f465c4ab Mon Sep 17 00:00:00
> > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Wed, 5 Nov 2008 19:00:36 -0800
> > Subject: [PATCH] scripts: script from kerneloops.org to pretty
> > print oops dumps
> >
> > We're strugling all the time to figure out where the code came from
> > that oopsed.. The script below (a adaption from a script used by
> > kerneloops.org) can help developers quite a bit, at least for
> > non-module cases.
> 
> Hi,
> 
> Just small style nitpicks below :-) (You pick which ones to heed.)

Hi,

I'm sure your nitpicks make the perl script more perl like, and are
good suggestions from that view.
However, I'm not a perl hacker, and neither are most other kernel
hackers, and to be honest, for me, the more a perl script looks like
"bash with regexps" the better, because I can actually read, understand
and debug it in that case ;-)

Greetings,
    Arjan van de Ven

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
