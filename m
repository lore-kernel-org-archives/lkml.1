Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbYCEXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbYCEXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765454AbYCEXNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:13:18 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63500 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbYCEXNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:13:14 -0500
Date: Wed, 5 Mar 2008 15:11:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Artie Ziff <artie.ziff@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: make target `headers_install'
Message-Id: <20080305151128.426192a1.randy.dunlap@oracle.com>
In-Reply-To: <47CF2525.9020304@gmail.com>
References: <47CF2525.9020304@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 14:56:37 -0800 Artie Ziff wrote:

> Hi!
> 
> Is headers_install a valid make target? Somone on the kernel irc said it
> was true, however when I run "make headers_install":
> 
> make: *** No rule to make target `headers_install'.  Stop.
> 
> object/goal: I am attempting to install the includes and set up the asm
> links (and whatnot), which is one step in a procedure to build a
> cross-compile toolchain.

headers_install is a valid make target is "recent" (last year or
so) kernels.  It's in the top-level Makefile.

What kernel version are you using?

---
~Randy
