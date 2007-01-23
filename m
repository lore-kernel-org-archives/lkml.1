Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbXAWRlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbXAWRlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 12:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965253AbXAWRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 12:41:31 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37428 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223AbXAWRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 12:41:31 -0500
Message-ID: <45B648CA.3020507@s5r6.in-berlin.de>
Date: Tue, 23 Jan 2007 18:41:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Sunil Naidu <akula2.shark@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Chuck Ebbert <cebbert@redhat.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Proposal] 2.6.18-stable release plans?
References: <45B53722.9030206@redhat.com>	 <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com> <8355959a0701230538m2f1201b6u49853e65d4c69a57@mail.gmail.com>
In-Reply-To: <8355959a0701230538m2f1201b6u49853e65d4c69a57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sunil Naidu wrote:
> I have to dig deep into the patch & kernel version to understand what
> are the features/implementations or fixes (patch).  Problem here is 2
> ways:-
> 
> 1) Identifying which is a better kernel (features) for
> Desktop/Embedded/Server (I know, info mentioned in Changelog. But
> still...)
> 
> 2) Easily knowing which stable patch applies for which arch or sub
> system (better way)
> 
> Proposal: Can maintainers implement this for better understanding of
> the Linux community (picking the best kernel or patch for the
> requirement) by adding a column on www.kernel.org home page?
...

This would be hard to organize and support. There are news sites like
LWN which give outlines of important kernel changes, and there are
mailinglists or community sites for architectures or driver subsystems
if you are interested in special platforms or drivers, and there is the
git repository metadata (via gitweb or directly from a locally cloned
git repo).

I for one am actually posting release notes to a users' mailinglist of
the drivers I'm interested in. But I can do this only because these are
drivers with very low rate of fixes or feature additions.

It's also not only a question of who writes such release notes, but also
of who the intended audience is. How fine-grained should the release
notes be?

Anyway --- if in doubt, your distributor's current kernel is the best one.
-- 
Stefan Richter
-=====-=-=== ---= =-===
http://arcgraph.de/sr/
