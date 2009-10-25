Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZJYW7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZJYW7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZJYW7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:59:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:14065 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZJYW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=F+2ork+/6IINQ1zRCWzwI4LRtKncTYMXJmlJjL9J4n6Opv5NHal7Xuj/pPtRxDYIjg
         bvByAb0rL+bNrOYUgN3SqBxl+xOAHYMCWPNoX09g4wW4wVwHJecfO9X2uELL7j55LgW8
         SeWtmSBOcgEv+z9sTFMycWRJ7p9KkrEkYJpUI=
MIME-Version: 1.0
Date: Sun, 25 Oct 2009 18:59:42 -0400
Message-ID: <deaa866a0910251559r6c001e6ek553256ac8f81b1f7@mail.gmail.com>
Subject: RFC: Updating the LKML bug reporting/updating framework
From: Robert Bradbury <robert.bradbury@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not know much in these areas having learned my craft by digging
UNIX source code listings out of wastebaskets at Harvard (freshman
weren't really supposed to have access to the UNIX source code in
1974).  And I hardly ever used the Oracle bug reporting system in the
mid-1980s.  But I have used the Mozilla, Gnome and Gentoo public bug
reporting and tracking systems to a fair extent in recent years and
they seem to work fairly effectively.

They have good search engines.  They attach patches to bug reports
which fix the stated problems.  They allow for discussion, assessment,
voting and presumably for the powers in charge the keeping of
statistics regarding the state of the software.

Now, the LKML seems to to be a throwback almost to 1971 when the first
email messages were sent between a couple of PDP-10s.  It has patches
that I have no interest in, discussions I have no interest in and were
it not for Gmail's search function it would be generally useless (very
high Noise-to-Signal ratio).  Now maybe I do not understand the Linux
development process.  Maybe this is a "Wizard of Oz" case and there is
a hidden bug reporting system hidden behind the curtain -- but in
spite of my best efforts I cannot locate it.

Why in this day and age (ignoring historical inertia) has Linux failed
to adopt a robust (modern) bug reporting system?
Can this be fixed?  Or is Linux really a case of a "proprietary
software" system pretending to be open [1]?

Robert Bradbury

1. If a software system is so complex that its quirks and pitfalls
cannot easily be located and avoided (witness the ondemand scheduler
problem on Pentium IV's message I recently filed) then is it not
*effectively* open source.  I am qualified to read hardware manuals, I
am qualified to rewrite C code (having written code generators for
several C compilers) but the LKML is like the windmill and I feel like
Don Quixote tilting back and forth in front of it.  One could even
argue that the lack of an open bug reporting system (and "current
state" online reports) effectively makes Linux a non-open-source
system.  Should not Linux be the one of the first systems to make all
knowledge completely available?  Or is it doomed to be replaced by
systems which might provide such capabilities (Android perhaps???)
