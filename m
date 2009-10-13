Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZJMQYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZJMQYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZJMQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:24:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:46700
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZJMQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:24:54 -0400
Message-ID: <4AD4B8C9.5000208@microgate.com>
Date: Tue, 13 Oct 2009 11:28:41 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>  <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>  <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>  <87ljjgfcbu.fsf@spindle.srvr.nix>  <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>  <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>  <20091013113232.384b2432@lxorguk.ukuu.org.uk>  <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain> <1255447980.3898.3.camel@x2.microgate.com> <alpine.LFD.2.01.0910130837370.26777@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910130837370.26777@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> What _you_ are talking about is something else, namely the 
> tty_prepare_flip stuff. But dammit, that has nothing what-so-ever to do 
> with "tty_buffer_request_room()".

OK, I should have followed your argument more closely.
I was trying to interpret it in terms of your patch,
which touched the tty_prepare stuff, but that is separate
from your comments about optimizations.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
