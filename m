Return-Path: <linux-kernel-owner+w=401wt.eu-S1767423AbXCIRLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767423AbXCIRLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767427AbXCIRLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:11:02 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:47985 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767425AbXCIRLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NjQaxW8gTqugAB3TGKpYQzxHJZN1C6TD7zcQq+UHaOSbLrUr3CGC732jvHJ2UHG4ctimVklB2ERQy/Hc5rhybjTRcOTACPj/UNhdfvRSRBc0knpLsFFfagRqzOaar2mpnCxCkP3uQNKz0wdVBtRDDAWfeB2gcWrczb5Fg9uTEiY=
Message-ID: <4af2d03a0703090910g4473e351k988a96f9e79a0d07@mail.gmail.com>
Date: Fri, 9 Mar 2007 18:10:57 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Richard Purdie" <rpurdie@rpsys.net>
In-Reply-To: <4af2d03a0703090848g67b77f78ie98e359bbd97d5ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>
	 <20070303094125.838ce04d.akpm@linux-foundation.org>
	 <45F13791.8040408@gmail.com>
	 <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
	 <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
	 <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
	 <4af2d03a0703090848g67b77f78ie98e359bbd97d5ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> I don't know if this is related, but my notebook keyboard doesn't emit
> numbers with numlock (not even directly Fn+blue number) anymore with
> -rc3 (note that LED is flashing when numlock is on). I think -rc2
> worked fine (I'm going to check this too). It's Asus M6R, similar
> (except wi-fi) to for example yenya's model here:
> http://www.fi.muni.cz/~kas/m6r/

Ignore this, it's deux ex machina, it works now.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
