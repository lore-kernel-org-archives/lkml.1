Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZAEKhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZAEKhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZAEKgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:36:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54277
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbZAEKgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:36:54 -0500
Date: Mon, 05 Jan 2009 02:36:54 -0800 (PST)
Message-Id: <20090105.023654.61507348.davem@davemloft.net>
To: mingo@elte.hu
Cc: sam@ravnborg.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090105101006.GA2059@elte.hu>
References: <20090105092110.GA11941@elte.hu>
	<20090105093931.GA17944@uranus.ravnborg.org>
	<20090105101006.GA2059@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 5 Jan 2009 11:10:06 +0100

> That is quite backwards, no matter how i look at it. Why doesnt Sparc do 
> the obvious and turn off -Werror until it has gotten around to fix those 
> few remaining warnings?

Are you kidding me?

-Werror has been on for 5+ years under arch/sparc, and the tree in
those subdirectories always built warning free.

For crying out loud, Sam and I are asking for a few days to freshen
up these patches so they build properly.  What is the big deal?

The changes will go in, probably within the next week, just give us
a chance to fix them up.

I really can't believe what a big stink is being made in response
to an arch maintainer and one of his helpers wanting to clean up
a patch before it gets integrated.
