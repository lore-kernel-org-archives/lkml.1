Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbXKVABF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbXKVABF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXKVAA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:00:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:38631 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXKVAAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:00:55 -0500
Subject: Re: radeonfb i2c regression post-2.6.18.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <877ikbf90q.fsf@hardknott.home>
References: <1195427766.7022.18.camel@pasglop>
	 <87oddoaqa6.fsf@hardknott.home> <1195675089.6970.96.camel@pasglop>
	 <877ikbf90q.fsf@hardknott.home>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 11:00:47 +1100
Message-Id: <1195689647.6970.119.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-21 at 23:56 +0000, Roger Leigh wrote:
> Fantastic, thanks!  I've copied this to Debian bugs 433236 and 426124
> which were about this problem.
> 
> BTW, the framebuffer penguin logo looked a little wierd (low number of
> colours, odd colours), though on my powerpc it has always looked odd
> (wrong colours).  Could there be some endianness bug in the fblogo
> code?  I'll check it with other video options when I next have a few
> minutes.

Strange, it's always been working fine for me.

Ben.


