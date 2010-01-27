Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055Ab0A0Vg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0A0Vg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122Ab0A0Vg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:36:28 -0500
Received: from www84.your-server.de ([213.133.104.84]:43924 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0A0Vg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:36:28 -0500
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
From: Stefani Seibold <stefani@seibold.net>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com
In-Reply-To: <4B60A288.2010909@austin.ibm.com>
References: <1264597747.3607.29.camel@wall-e>
	 <4B6080C5.7020306@austin.ibm.com> <4B608D78.4040606@caviumnetworks.com>
	 <4B60A288.2010909@austin.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Jan 2010 22:36:24 +0100
Message-ID: <1264628184.11228.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 27.01.2010, 14:31 -0600 schrieb Joel Schopp:
> >>
> >>
> >> While the origins of 80 character lines dates back to punchcards 
> >> there is a reason it has survived the test of time.
> >
> > Has it though?  If that were the undisputed truth, we wouldn't be 
> > having this discussion.
> 
> If you know of a usability study that quantifies the effect of line 
> length on readibility of C code I'm willing to listen, and I'm sure 
> others are too.

Show me the usability study with claims that 80 columns is the wisdom in
software engineering. Why not 73, 90 or 95? The only reason for the 80
columns is a historic one. 

And the programming rules for linux doesn't manifest the 80 character
per line.

Code will get in many cases harder to read, especially together with the
tab size of 8. Multiline C statements makes the code IMHO harder to
read.

Stefani


