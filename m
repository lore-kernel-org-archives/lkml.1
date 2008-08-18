Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbYHRFbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbYHRFbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 01:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYHRFbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 01:31:07 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:46710 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750848AbYHRFbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 01:31:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0RX7Cur051xTTSqLKsqKUW07ldP89At67I3ffKp/ycPnjfBv9Wt28A6V5HX8YNOdU8g+9Rni9Kc85ozhXtnhtMJi/6e3cRIOsgM0S7Jci1sxsgAmIu+n8r74moOK/zrE6yXIsLjRNJR20uSnJCZnU9LceFdX5C6BQoYvWA2LMco=  ;
X-YMail-OSG: Err_X2QVM1k5Olza_opD4VZlxgZCGYgFvj78SvwNokxJzEEV.H8ExY6VaKYqMFPV3JLFF2PJYmBVHEf8Mj6TGt5MPaCW9SB4ntnoSWFBt163EZ2Tj1zxhDqueoauEw5UDuM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Shane <gnome42@gmail.com>
Subject: Re: WTF does -rc mean? was [PATCH] x86, tsc: fix section mismatch warning
Date: Mon, 18 Aug 2008 15:30:50 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <fa4052ef0808172003r48863a4fu90c0647eef736571@mail.gmail.com>
In-Reply-To: <fa4052ef0808172003r48863a4fu90c0647eef736571@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181530.50995.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 13:03, Shane wrote:

> This is the third** -rc cycle where I have composed what is meant to
> be a scorching
> email to the kernel list about the mind blowing decline in -rc kernel
> developer attitude.
> I didn't send the other two but I just spent another two flippin'
> hours booting and
> fsck'in. And I am very cranky  (to put it politely) because the
> bleep'n problem is known
> and the fix has been available for at least 7 days!!
>
> I of course understand that there will be bugs in the -rc kernels,
> that is why I bother putting
> the time and energy into testing them.  It is mainly the lackadaisical
> attitude about getting
> the fixes in that is a mind blower.
>
> I am a (fairly long time) tester/luser of the kernel. I do it for fun
> and to learn.
> It isn't fun anymore.

It stands for "ridiculous count". I'm not joking.

If you want something approaching a "release candidate", you have to
use the last one or two -rcN releases before the final release. This
obviously requires guesswork.
