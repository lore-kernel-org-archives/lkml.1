Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYLaXTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYLaXTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 18:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYLaXT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 18:19:29 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:34851 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYLaXT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 18:19:28 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <20081231104533.abfb1cf9.akpm@linux-foundation.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 18:19:09 -0500
Message-Id: <1230765549.7538.8.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.495BFDF1.0027:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 10:45 -0800, Andrew Morton wrote:
> On Wed, 31 Dec 2008 06:28:55 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> 
> > Hello everyone,
> 
> Hi!
> 
> > I've done some testing against Linus' git tree from last night and the
> > current btrfs trees still work well.
> 
> what's btrfs?  I think I've heard the name before, but I've never
> seen the patches :)

The source is up to around 38k loc, I thought it better to use that http
thing for people who were interested in the code.

There is also a standalone git repo:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git;a=summary

This has only btrfs as a module and would be the fastest way to see
the .c files.  btrfs doesn't have any changes outside of fs/Makefile and
fs/Kconfig

(happy new year ;)

-chris


