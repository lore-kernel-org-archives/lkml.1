Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYGYPeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYGYPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYGYPei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:34:38 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:50974 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYGYPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:34:37 -0400
Message-ID: <4889F28B.6000307@idilia.com>
Date: Fri, 25 Jul 2008 11:34:35 -0400
From: Filipe Brandenburger <filipe.brandenburger@idilia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Recommendation on an eSATA card well supported by Linux with
 built-in drivers and that supports hot plug
References: <fa.jn2UBng193xTV9fhfIdhKpQQKRo@ifi.uio.no> <4888E188.4050708@shaw.ca> <488900E2.4000208@zytor.com>
In-Reply-To: <488900E2.4000208@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Robert Hancock wrote:
>> Most AHCI controllers are built into chipsets, but I know that JMicron
>> has some chips which can be found on add-in cards which are AHCI.
> 
> They work, and they're cheap.

That's great, I actually stumbled upon them. I believe AHCI is really
the way to go, open standard, excellent support in kernel, probably will
live very long.

However, I'm having a hard time finding a brand that uses these chips. I
see that apparently there is one called "VIBE" that uses it, but I got
this information from an online store and I didn't even find the
vendor's website...

Would you be also so kind as to recommend an actual eSATA card that uses
the JMicron chip? Preferrably one that you have and use on a daily basis.

Excuse me if the subject matter has gone way off-topic for this list,
however the advice is being great.

Thanks,
Filipe
