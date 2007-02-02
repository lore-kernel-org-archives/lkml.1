Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXBBHMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXBBHMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXBBHMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:12:34 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:40847 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXBBHMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:12:33 -0500
Date: Fri, 2 Feb 2007 08:12:28 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion  system calls
Message-ID: <20070202071227.GA31017@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net> <20070201202633.GA14021@outpost.ds9a.nl> <6F32C88B-8466-4952-8D24-94076FB235DD@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F32C88B-8466-4952-8D24-94076FB235DD@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:29:41PM -0800, Zach Brown wrote:

> >I want to try it on from a userspace perspective.
> 
> Frankly, I'm not sure its ready for that yet.  You're welcome to give  
> it a try, but it's early enough that you're sure to hit problems  
> almost immediately.

I'm counting on it - what I want to taste is if the concept is a match for
the things I want to do.

Thanks!

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
