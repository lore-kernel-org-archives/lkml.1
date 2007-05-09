Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbXEIPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbXEIPuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbXEIPt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:49:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11555 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbXEIPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:49:55 -0400
Date: Wed, 9 May 2007 08:52:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, jeremy@goop.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: volatile considered evil
Message-Id: <20070509085253.5935f90f.randy.dunlap@oracle.com>
In-Reply-To: <46418B4D.6030307@s5r6.in-berlin.de>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
	<20070508163452.8b71f682.randy.dunlap@oracle.com>
	<46418B4D.6030307@s5r6.in-berlin.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 10:50:21 +0200 Stefan Richter wrote:

> Randy Dunlap wrote:
> > Add information on the problems with the C-language "volatile" keyword
> > and why it should not be used (most of the time).
> 
> I like Jonathan's article http://lwn.net/Articles/233479/ a lot.
> It puts as much emphasis on the DOs as on the DON'Ts, which I find helpful.

Yep.  I expect to drop my patch in favor of Jon's writeup.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
