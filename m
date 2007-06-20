Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXFTXwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXFTXwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbXFTXwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:52:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:32794 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbXFTXw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:52:29 -0400
Date: Thu, 21 Jun 2007 01:51:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, torvalds@linux-foundation.org
Subject: Re: [PATCH] blink: Only blink when parameter is set
In-Reply-To: <20070620201637.GA5610@ucw.cz>
Message-ID: <Pine.LNX.4.64.0706210147260.3068@twin.jikos.cz>
References: <20070617083904.GC4496@suse.de> <20070620201637.GA5610@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Pavel Machek wrote:

> * It breaks keyboards. Yes, we are talking about maybe-broken i8042s, 
>   but it still breaks thinkpads at least.

Hi Pavel,

this has probably been already solved by proper throttling - see 
http://lkml.org/lkml/2007/6/15/22

-- 
Jiri Kosina
