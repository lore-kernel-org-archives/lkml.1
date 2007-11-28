Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXK1SAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXK1SAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXK1SA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:00:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41978 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbXK1SAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:00:25 -0500
Date: Wed, 28 Nov 2007 17:54:37 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jean Delvare <khali@linux-fr.org>, Adrian Bunk <bunk@kernel.org>,
       i2c@lm-sensors.org, Lennert Buytenhek <buytenh@wantstofly.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128175437.GA1774@flint.arm.linux.org.uk>
References: <20071024162528.GX30533@stusta.de> <20071024164347.GN4003@csclub.uwaterloo.ca> <20071128112357.3828d469@hyperion.delvare> <20071128173022.GD2308@csclub.uwaterloo.ca> <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:43:00PM -0500, Jon Smirl wrote:
> Hasn't their been a one year notice that these drivers were going to
> be removed? How about removing them and putting them into a tarball on
> the i2c web site with a note explaining about how they need to be
> updated to use the gpio driver? Then if someone really wants to use
> the old drivers they can use them out of tree.

It hasn't been a year - they were added to feature-removal on May 1st.

However, not all the relevant people were made aware of that fact.
Yes, Deepak was copied on that message, but I think he's moved on to
other things.  On the other hand, Lennert (who is listed as IXP2000
maintainer) is completely unaware of these drivers being marked
obsolete.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
