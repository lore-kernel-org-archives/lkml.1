Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbXBOGLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbXBOGLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXBOGLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:11:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXBOGLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:11:52 -0500
Date: Thu, 15 Feb 2007 01:11:49 -0500
From: Dave Jones <davej@redhat.com>
To: v j <vj.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070215061149.GE15654@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, v j <vj.linux@gmail.com>,
	linux-kernel@vger.kernel.org
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:16:28PM -0800, v j wrote:
 > This is in reference to the following thread:
 > 
 > http://lkml.org/lkml/2006/12/14/63
 > 
 > I am not sure if this is ever addressed in LKML, but linux is _very_
 > popular in the embedded space. We (an embedded vendor) chose Linux 3
 > years back because of its lack of royalty model, robustness and
 > availability of infinite number of open-source tools.
 
Welcome to three months ago.
Here in the future, this was deemed a non-issue.
However this does highlight another problem.
End-users who take linux for use in embedded systems (especially)
tend to live in their own little world rarely contributing anything
back to upstream, popping up occasionally when months after decisions
have been made on things.   Remind me again why we should care about
your out of tree binary only modules ?

 > The drivers which
 > we have written over the last three years are suddenly under threat.

Were they part of the kernel tree, people might care enough to
a) fix them so that they work and b) care enough that they _keep working_
even if people changing APIs etc don't have the necessary hardware.

This isn't the 1990s any more, we shouldn't need to explain how all this works.

 > However we have a worrying trend here. If at some point it becomes
 > illegal to load our modules into the linux kernel, then it is
 > unacceptable to us. We would have been better off choosing VxWorks or
 > OSE 3 years ago when we made an OS choice. The fact that Linux is
 > becoming more and more closed is very very alarming.

The question is "do you care about giving back" or are you intending
to leech of Linux and just complain when it changes in ways that
don't mesh with your plans?

		Dave

-- 
http://www.codemonkey.org.uk
