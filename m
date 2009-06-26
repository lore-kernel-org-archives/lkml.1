Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZFZGEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZFZGEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZFZGD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:03:56 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:48477 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZFZGDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:03:55 -0400
Message-ID: <4A4464CA.4060006@msgid.tls.msk.ru>
Date: Fri, 26 Jun 2009 10:03:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-input <linux-input@vger.kernel.org>, alsa-devel@vger.kernel.org
Subject: Re: PC speaker beeps in 2.6.30?
References: <4A365DA6.8000102@msgid.tls.msk.ru>
In-Reply-To: <4A365DA6.8000102@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding some more Cc's...]

Am I the only concerned about this?  My 2.6.30 is still
silent w.r.t. old good PC speaker beeps, and I wasn't
able to make it to produce any sound.  Yes, as pointed
out by others there is a control now, in alsa, and I
can hear ugly and scary beeps from my stereo speakers
(when they're turned on and when the control is un-muted).
But that's.. not a solution/answer to the original
question... ;)

Thanks!

Michael Tokarev wrote at Mon, 15 Jun 2009 18:41:42 +0400:
> Anyone know what happened with PC speaker in 2.6.30?
> Basically, it does not work anymore here, with the
> config which is very similar to the one used for
> previous 2.6.29 kernel (where PC speaker worked).
> At least I don't see any relevant differences and
> the (seemengly) relevant symbols -- which are
> INPUT_PCSPKR and PCSPKR_PLATFORM -- are both set
> to 'y' for both 2.6.29 and 2.6.30.
> 
> Help? :)
> 
> Thanks.
> 
> /mjt

