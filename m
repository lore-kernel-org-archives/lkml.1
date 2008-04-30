Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYD3WyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYD3WyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbYD3Wxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:53:49 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:60455 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbYD3Wxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:53:48 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 00:53:31 +0200
User-Agent: KMail/1.9.7
Cc: Dan Noe <dpn@isomerica.net>, torvalds@linux-foundation.org, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <4818DAC4.0@isomerica.net> <20080430135938.82e46e67.akpm@linux-foundation.org>
In-Reply-To: <20080430135938.82e46e67.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010053.31894.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Perhaps we should be clear and simple about what potential testers 
> > should be running at any given point in time.  With -mm, linux-next, 
> > linux-2.6, etc, as a newcomer I find it difficult to know where my 
> > testing time and energy is best directed.

Speaking of energy and time of a tester. I'd like to know where these resources
should be directed from the arch point of view. Once I had a plan to buy as
many arches as I could get and run a farm of test boxes 8-) But that's hard
because of various reasons (money, time, room, energy). What arches need more
attention? Which are forgotten? Which are going away? For example does buying
an alphaserver DS 20 (hey - it's cheap) and running tests on it makes sense
these days?

	Mariusz
