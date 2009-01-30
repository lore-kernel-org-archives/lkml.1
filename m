Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZA3T5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZA3T5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZA3T5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:57:34 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35753 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZA3T5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:57:33 -0500
Date: Fri, 30 Jan 2009 20:57:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc3 (git tree)
In-Reply-To: <49823542.4060202@oracle.com>
Message-ID: <alpine.LRH.1.10.0901302055270.13097@twin.jikos.cz>
References: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain> <49823542.4060202@oracle.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Randy Dunlap wrote:

> In the mainline kernel git tree, where are these files from
> and why?
> 
> ./crash_uni.patch
> arch/x86/kernel/rb32.log

I don't see these on current head (f2257b70), so it's probably your local 
issue.

$ git pull
Already up-to-date.
$ ll ./crash_uni.patch
ls: cannot access ./crash_uni.patch: No such file or directory
$ ll arch/x86/kernel/rb32.log
ls: cannot access arch/x86/kernel/rb32.log: No such file or directory

-- 
Jiri Kosina
SUSE Labs

