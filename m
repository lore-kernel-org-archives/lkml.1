Return-Path: <linux-kernel-owner+w=401wt.eu-S1765349AbXFFOkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765349AbXFFOkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXFFOkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:40:01 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:54470 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXFFOkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:40:01 -0400
Message-ID: <4666C73F.6080208@s5r6.in-berlin.de>
Date: Wed, 06 Jun 2007 16:39:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: tim.post@netkinetics.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel inclusion policy, meta desicion making structure?
References: <1180928198.5786.111.camel@localhost.localdomain>
In-Reply-To: <1180928198.5786.111.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Post wrote on 2007-06-04:
> I was wondering if a meta version of the decision making process that
> would be employed to determine if a new contribution does or does not go
> into the main stream Linux kernel.
[...]
> Does some document exist that shows the decision making process so that
> I can easily answer the ultimate question of "Why not" for myself?

There is documentation on how submissions should look like.  Other than
that, these are case-by-case decisions based on a number of factors.
Perhaps you should look up discussions on merge requests (accepted as
well as rejected ones) in archives or better at sources like LWN.net.

[...]
> I would like to write my own lightweight cluster file system and make
> modifications to existing cluster file systems.

If you don't want to start with an actual submission, you could begin
with discussing the specific features you have in mind directly with the
developers and maintainers of the existing cluster FSs.  Then it should
become clearer how to proceed most effectively.
-- 
Stefan Richter
-=====-=-=== -==- ---=-
http://arcgraph.de/sr/
