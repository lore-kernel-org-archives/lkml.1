Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXBDVde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXBDVde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXBDVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:33:34 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:53658 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbXBDVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:33:34 -0500
To: Greg KH <greg@kroah.com>
Cc: Andrew Lyon <andrew.lyon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com>
	<f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com>
	<20070130203039.GA23370@kroah.com> <m3y7neoxue.fsf@zoo.weinigel.se>
	<20070204181912.GA12379@kroah.com>
From: Christer Weinigel <christer@weinigel.se>
Organization: Weinigel Ingenjorsbyra AB
Date: 04 Feb 2007 22:33:33 +0100
In-Reply-To: <20070204181912.GA12379@kroah.com>
Message-ID: <m3ps8pppzm.fsf@zoo.weinigel.se>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> Or perhaps your device just needs to add some flow control to it :)

Physical processes are hard to pause. :-)

But yes, adding a 16kByte FIFO before the FT245 would have made life
so much easier for me, but unfortunately the thing that drives the
hardware choice is cost, cost and cost.  

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
