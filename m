Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXHEOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXHEOyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXHEOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:54:08 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57307
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHEOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:54:06 -0400
Subject: Re: serial flow control appears broken
From: Paul Fulghum <paulkf@microgate.com>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Tilman Schmidt <tilman@imap.cc>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B51308.4010402@howardsilvan.com>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
	 <20070726173121.70088a92@the-village.bc.nu>
	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>
	 <46D33636.7070200@microgate.com> <46AA5A0E.1050600@howardsilvan.com>
	 <1185578908.2989.15.camel@x2> <46AACB4D.7080004@howardsilvan.com>
	 <2c0942db0707280941n1b9e1f7i9c0de332286e8aac@mail.gmail.com>
	 <46B4C393.4020506@howardsilvan.com> <46B4F8AD.3000405@microgate.com>
	 <46B51308.4010402@howardsilvan.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 09:52:06 -0500
Message-Id: <1186325526.3209.5.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.2.5 is using the same UART setup (trigger level of 8) as
the current code. There is no obvious difference in the
interrupt setup (same devices on the same interrupts).

So I have no helpful suggestions :-(

--
Paul


