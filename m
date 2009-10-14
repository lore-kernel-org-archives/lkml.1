Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZJNBfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZJNBfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZJNBfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:35:45 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:58172
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZJNBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:35:44 -0400
Message-ID: <4AD52AC0.9010101@microgate.com>
Date: Tue, 13 Oct 2009 20:34:56 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "" <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>  <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>  <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>  <87ljjgfcbu.fsf@spindle.srvr.nix>  <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>  <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>  <4AD3F769.5080405@gmail.com>  <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>  <4AD437F9.9020708@yahoo.co.uk>  <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>  <4AD4DE4C.4010402@yahoo.co.uk>  <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>  <4AD4F548.2030506@microgate.com>  <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Do you even bother reading my emails?

Yes, they are very colorful.

> Let me walk through an example of where the locking F*CKS UP, exactly 
> because it's broken.

OK, I got it this time.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
