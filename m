Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbZD3R5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbZD3R5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbZD3RjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:39:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42610
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933588AbZD3RjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:39:20 -0400
Date: Thu, 30 Apr 2009 10:39:13 -0700 (PDT)
Message-Id: <20090430.103913.173722554.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arch@vger.kernel.org, monstr@monstr.eu,
       remis.developer@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/27] asm-generic: add generic versions of common
 headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904301934.59415.arnd@arndb.de>
References: <200904301907.46515.arnd@arndb.de>
	<20090430.101231.27030060.davem@davemloft.net>
	<200904301934.59415.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 30 Apr 2009 19:34:58 +0200

> On Thursday 30 April 2009, David Miller wrote:
>> You didn't read what I said.
>> 
>> I extract the commit messages and patches using "git format-patch"
>> merely as a formality, then I hand craft every aspect of the emails.
> 
> Right, this is what I do for smaller sets of patches, but I was
> hoping for something slightly simpler when sending out my 27 (plus
> the previous 18) patches.

You shouldn't be bombing the list with so many patches at once,
another good reason to do it by hand :-)

Either consolidate or send in multiple phases after the initial
patches of infrastructure and examples are OK'd by everyone.
