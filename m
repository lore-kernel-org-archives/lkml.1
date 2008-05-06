Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYEFO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYEFO4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYEFO4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:56:12 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50631 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYEFO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:56:12 -0400
Message-ID: <48207142.6060702@s5r6.in-berlin.de>
Date: Tue, 06 May 2008 16:54:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk> <20080506073134.424780a3@gaivota> <48206C73.80509@s5r6.in-berlin.de>
In-Reply-To: <48206C73.80509@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> If A selects B, you have to copy all of B's
> dependencies to A or select these dependencies by A.
> 
> So it's totally simple to do it right.  The only nuisance is that you
> always have to update B's dependencies and selections whenever A's
> dependencies are changed.

Switch A and B in the last sentence. :-)
-- 
Stefan Richter
-=====-==--- -=-= --==-
http://arcgraph.de/sr/
