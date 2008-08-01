Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYHAF3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYHAF3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYHAF3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:29:39 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:38127 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYHAF3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:29:38 -0400
Date: Fri, 1 Aug 2008 15:29:36 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on powerpc
Message-ID: <20080801052936.GZ20457@bakeyournoodle.com>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <4891B370.5040208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4891B370.5040208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 06:13:28PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> make allyesconfig with 2.6.27-rc1-mm1 kernel on powerpc fails with build error

<snip>

Turning off GCOV "fixes" this.  Not really the best solution but at
least it narrows doen the search effort.

Peter,
	Can you have a look at how this can be fixed, if at all?

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

