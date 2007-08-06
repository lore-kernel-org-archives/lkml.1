Return-Path: <linux-kernel-owner+w=401wt.eu-S1765116AbXHFRcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765116AbXHFRcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbXHFRcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:32:10 -0400
Received: from neon.samage.net ([85.17.153.66]:39163 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbXHFRcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:32:08 -0400
Message-ID: <59814.81.207.0.53.1186421522.squirrel@secure.samage.net>
In-Reply-To: <46B75784.5030502@zytor.com>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
    <1186317610.5220.3.camel@daplas>
    <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
    <Pine.LNX.4.64.0708061739100.13469@fbirervta.pbzchgretzou.qr>
    <b6a2187b0708060906k643a8a20jcb3ac33259993517@mail.gmail.com>
    <39839.81.207.0.53.1186418772.squirrel@secure.samage.net>
    <46B75784.5030502@zytor.com>
Date: Mon, 6 Aug 2007 19:32:02 +0200 (CEST)
Subject: Re: Linux 2.6.23-rc2
From: "Indan Zupancic" <indan@nul.nu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 964c6a2bc69af72888bec91466701c23
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 6, 2007 19:16, H. Peter Anvin wrote:
> Indan Zupancic wrote:
>>
>> Does executing unicode_start, unicode_stop fixes it?
>>
>
> Does that seem likely, since his display isn't even in text mode?

No idea, just thought it would be worth a try. My console is garbled
too, doing that unicode stuff fixed it for me. (Though it appears to
work better nowaday: new text is fine and other than the first consoles
are fine too, which wasn't the case a while ago I think.)

I thought he was using a VGA console, wouldn't that be in text mode?

Greetings,

Indan


