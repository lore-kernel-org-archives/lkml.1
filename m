Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYITVW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYITVW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYITVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:22:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7545 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYITVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:22:48 -0400
Message-ID: <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com>
Date: Sat, 20 Sep 2008 14:22:46 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
	 <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 2:03 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>
> OK so yeah you have an interrupt storm, this is evident.

Indeedy.

>
> Do you think there is a way you can try to trigger the interrupt storm
> so it happens < than after 7 hours or however long its taking you? If
> so then it'd be good to get your debug out using the interrupt debug.
> If that's not useful then we can enable all debug stuff (file will be
> huge).

It's apparently 7 idle hours and ~1-2 hours when I'm actively browsing
the web. I don't know what in particular triggers it, so I guess I'd
just need to enable debug logging and then start running through all
my webcomics, or perhaps perusing Wikipedia.

> Try turning on the microwave, turn on all  your bluetooth devices, use
> your 2.4 GHz wireless phone, use your xbox 360 controllers and ps3
> controllers all at once :D

Heh. I don't have an Xbox 360 or PS3 (sad, I know). Do have several
2.4GHz phones. ;)
