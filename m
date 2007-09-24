Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXIXAH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXIXAH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXIXAHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 20:07:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:56167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXIXAHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 20:07:22 -0400
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mihai =?UTF-8?Q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200709232222.29066.mihai.dontu@gmail.com>
References: <200709220828.00078.mihai.dontu@gmail.com>
	 <200709232131.02348.mihai.dontu@gmail.com> <200709232118.09884.rjw@sisk.pl>
	 <200709232222.29066.mihai.dontu@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 24 Sep 2007 10:06:50 +1000
Message-Id: <1190592411.6886.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-09-23 at 22:22 +0300, Mihai Donțu wrote:
> 
>   Bottom line: no radeonfb for me :( at least, not now; but I have to
> be honest with
>   you: I don't see what commit
> dd1447134454b169d5ae353aceb93f2368db8547 brought new
>   into the picture. The previous radeonfb worked just great, but then,
> again, maybe I'm
>   not using the console at it's full power :)

It might have simply not initialized :-)

Ben.


