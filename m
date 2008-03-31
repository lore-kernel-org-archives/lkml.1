Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCaSVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCaSVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYCaSVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:21:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYCaSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:21:48 -0400
Date: Mon, 31 Mar 2008 11:21:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org>
References: <200803220259.48534.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10291
> Subject		: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
> Submitter	: Tino Keitel <tino.keitel@gmx.de>
> Date		: 2008-03-20 07:05 (2 days old)
> References	: http://lkml.org/lkml/2008/3/20/23

Hmm. I just tested mine, and it still works fine (current -git, 
obviously). But as usual, I tend to run different kernel configs than most 
people (no modules, only drivers that are actually useful). So I think 
this needs bisecting or something.

		Linus
