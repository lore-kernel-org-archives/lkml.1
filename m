Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZK3Ugj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZK3Ugj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZK3Ugi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:36:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49494
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbZK3Ugi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:36:38 -0500
Date: Mon, 30 Nov 2009 12:36:44 -0800 (PST)
Message-Id: <20091130.123644.203668577.davem@davemloft.net>
To: william.allen.simpson@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: warning: massive change to conditional coding style in net?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B13A025.7000103@gmail.com>
References: <4B13A025.7000103@gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Mon, 30 Nov 2009 05:36:21 -0500

> Over the past several days, David Miller (with help from Joe Perches)
> made sweeping changes to the format of conditional statements in the
> net tree -- the equivalent of mass patches that change spaces.
> 
> This makes writing patches for multiple versions of the tree very
> difficult, and will make future pullups problematic.  It's enough to
> make a grown man cry....  Patching conflicts everywhere!

William, you're unreasonable.

We asked you to follow a certain style, and then you immediately
complain that the style isn't followed consistently in the tree, and
therefore as a consequence you shouldn't be required to follow it.

Then Joe comes and submits patches making the tree follow the style
more consistently.  See, instead of merely complaining like you did,
he proactively did something positive.

Now you're complaining because this makes your patches harder to
maintain.

You're being difficult about this from every possible angle.  I can
only conclude that for whatever reason you don't want to have any
requirements made upon you for your submission.  You've handled this
negatively in every way possible, and every step of the way.  No
matter how hard other people have been to try and help you, you've
continued to do this.

Whereas if you had merely fixed up the coding style as I and others
have asked you, your code would be in my tree weeks ago.

Why is it such a huge deal to follow the coding style that the
maintainer (and other prominent developers of that subsystem) are
asking you to follow?
