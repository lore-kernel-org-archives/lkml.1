Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZKORei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZKORei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 12:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZKORei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 12:34:38 -0500
Received: from fifo99.com ([67.223.236.141]:38295 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZKOReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 12:34:37 -0500
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Daniel Walker <dwalker@fifo99.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <94a0d4530911150927l3224e815ha6ff17aab6f19251@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
	 <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
	 <1258305351.6428.8.camel@desktop>
	 <94a0d4530911150927l3224e815ha6ff17aab6f19251@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 15 Nov 2009 09:32:32 -0800
Message-Id: <1258306352.6428.10.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 19:27 +0200, Felipe Contreras wrote:
> On Sun, Nov 15, 2009 at 7:15 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Fri, 2009-11-13 at 22:28 +0200, Felipe Contreras wrote:
> >> That doesn't seem too positive. Or at least there's no indication that
> >> somebody will pick it up.
> >
> > I'd re-submit with a better description of the patch. You should always
> > try to describe what your doing as accurately as possible so the
> > maintainer doesn't have to work very hard to know what your doing.
> 
> There's nothing to add. It's a patch to cleanup the coding style, that's it.

How do you know the coding style isn't correct? Did you just visually
inspect it?

> > That
> > particular patch just has a one liner description that wasn't very
> > informative .. Either that or re-submit your series without that patch
> > if you don't have confidence in it.
> 
> All of my patches have been picked up, except the ones for ACPI. I
> haven't received a single comment from them, which would explain the
> current state of the code.
> 
> If somebody raised the hand and said; I'll merge this, please resend,
> I'd do that, otherwise I think it's a waste of time.

Patches often times aren't accepted in the first submission, could be
for lots of reasons. It's your series tho ..

Daniel

