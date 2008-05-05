Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYEEE0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYEEE0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYEEE02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:26:28 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:64455 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYEEE01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:26:27 -0400
Message-ID: <481E8C64.7090507@aknet.ru>
Date: Mon, 05 May 2008 08:26:12 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch][resend] pcspkr: fix dependancies
References: <481D3A08.2040500@aknet.ru> <20080505035733.GA11584@anvil.corenet.prv>
In-Reply-To: <20080505035733.GA11584@anvil.corenet.prv>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dmitry Torokhov wrote:
>> Dmitry, would you mind applying this one?
>> If not, then I see no way to get either
>> fix applied...
> Ok, but don't you need to also add the same dependancy for SND_PCSP?
Thanks!
As for SND_PCSP - I decided to skip
that part and send it as a separate
patch to Takashi, when this one is
settled. Otherwise it would be even
more difficult to find the right person
to apply the whole thing. :)
