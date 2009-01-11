Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZAKAJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZAKAJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZAKAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:09:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZAKAJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:09:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.28-git-4 - powerpc - kernel expection 'c01 at .kernel_thread'
Date: Sun, 11 Jan 2009 01:08:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-mm@kvack.org,
       sfr@canb.auug.org.au, benh@kernel.crashing.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, mel@csn.ul.ie
References: <20090102125752.GA5743@linux.vnet.ibm.com>
In-Reply-To: <20090102125752.GA5743@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901110108.20848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009, Kamalesh Babulal wrote:
> Hi,
> 
> 	2.6.28-git4 kernel drops to xmon with kernel expection. Similar kernel
> expection was seen next-20081230 and next-20081231 and was reported 
> earlier at http://lkml.org/lkml/2008/12/31/157

Is this a regression from 2.6.27?

Rafael
