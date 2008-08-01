Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYHAQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYHAQxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYHAQxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:53:36 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:19724 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYHAQxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:53:35 -0400
Date: Fri, 1 Aug 2008 18:45:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on powerpc
Message-ID: <20080801164525.GA2299@uranus.ravnborg.org>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <4891B370.5040208@linux.vnet.ibm.com> <20080801052936.GZ20457@bakeyournoodle.com> <20080731231206.80940fba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731231206.80940fba.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Am not terribly happy with the state of the gcov patches.  They STILL
> leave thousands of dead symlinks lying around after `make mrproper' and
> generally seem to muck up the kbuild system a bit, although nothing
> that a bit of Sam love wouldn't fix.

Have not had time / energy to get aroud to it.
Other things continue to pop up and time is limited at the moment
as in more limited than usual).

	Sam
