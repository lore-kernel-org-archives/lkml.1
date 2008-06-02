Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYFBTUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYFBTUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYFBTUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:20:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2170 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752262AbYFBTUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:20:23 -0400
Date: Mon, 2 Jun 2008 21:20:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080602192012.GA7748@ucw.cz>
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4842BB89.5090908@diamondcut.com.br>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > (And yes, your hw is broken; on pc it is traditionaly hw
> > responsibility to power machine down.)
> 
> OK, I try do this but I think this is very difficult because demand
> power is very low and is not enought to do hot some component. But I
> will try.
> 
> I don't think that my hardware is broked because I don't have this kind
> of problem on Kernel <=2.6.22 or in other OS.

Can you try to find out when that started happening?

does it still happen with acpi=off ?

does it each too much power if you use 4second hold of power button to
shut it down from running linux?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
