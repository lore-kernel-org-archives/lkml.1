Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZJZSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZJZSl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZJZSlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:41:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48409 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZJZSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:41:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE5ED2D.2010708@s5r6.in-berlin.de>
Date: Mon, 26 Oct 2009 19:40:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Robert Bradbury <robert.bradbury@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>
Subject: Re: RFC: Updating the LKML bug reporting/updating framework
References: <deaa866a0910251559r6c001e6ek553256ac8f81b1f7@mail.gmail.com> <4AE4E026.9070402@mandriva.org> <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com> <20091026145637.GE13941@mit.edu>
In-Reply-To: <20091026145637.GE13941@mit.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Most end users who use a Linux distribution will have a much better
> time if they use the support channels (bugzilla, irc, web forums,
> etc.) for their particular Linux distribution.
[...]
> even some community distributions, such as
> Ubuntu, do add a significant number of "value add" (and thus, bugs :-)
> to their kernels.

The downside is that such bugtrackers appear to be chronically
understaffed in the triage department.  Therefore, bugs which could look
like potential upstream bugs to a somewhat trained eye are far too
rarely reported to upstream by distro bug triage teams.

> There are also individual sublists for people who are only working on
> a specific part of the kernel (i.e., the linux-ext4 mailing list, the
> linux-scsi mailing list, etc).

Robert,

these mailing lists can be found in the MAINTAINERS file in the root of
the kernel sources.  The reporting-bugs page which Thomas mentioned
points to this file as a source for contact persons, but the list
addresses in there are IMO even more important.

About bugzilla.kernel.org:  It's more a tracker than a reporting tool.
-- 
Stefan Richter
-=====-==--= =-=- ==-=-
http://arcgraph.de/sr/
