Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXFDOnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXFDOnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbXFDOnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:43:33 -0400
Received: from neon.samage.net ([85.17.153.66]:54894 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbXFDOnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:43:32 -0400
Message-ID: <3617.81.207.0.53.1180968208.squirrel@secure.samage.net>
In-Reply-To: <Pine.LNX.4.64.0706041437030.29896@twin.jikos.cz>
References: <20070604112426.GA2707@elf.ucw.cz>
    <4945.81.207.0.53.1180960534.squirrel@secure.samage.net>
    <Pine.LNX.4.64.0706041437030.29896@twin.jikos.cz>
Date: Mon, 4 Jun 2007 16:43:28 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, dtor@insightbb.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 7b320cd02cd98c580351ccd23ba1512a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, June 4, 2007 14:38, Jiri Kosina wrote:
> On Mon, 4 Jun 2007, Indan Zupancic wrote:
>
>> > I also get some stuck keys I was not getting before. I hope my
>> > userland did not go crazy...
>> I get that too, and wasn't sure about it either. It happens irregularly,
>> so it's hard to debug, but often enough to be annoying.
>
> What kind of keyboards are they? I guess the x60 case is serio/ps2, what
> keyboard do you experience this with, Indan?

Also serio/ps2:
input: AT Translated Set 2 keyboard as /class/input/input0


