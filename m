Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZELQn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZELQn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZELQns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:43:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:48558 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZELQnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SsgE3yVgbq1rsrbDeazTAh+0h3AqDneOJc7TGUPh2OUEZrOzkxKWK5WPgSakvs72CS
         1En2IeDHrsBEMzk1onu/6rwiL8ewZWLvo5jJt5lXezuFPRU4fFCRwEYSaMfGolQ2vVbg
         X1C9mTnobPMuh2GRLENMd66w56QKWCfiH7XJA=
MIME-Version: 1.0
In-Reply-To: <b6c5339f0905120803l497131e9k7efc1b26aeb14448@mail.gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com> <1242080334.1991.11.camel@unix>
	 <b6c5339f0905120803l497131e9k7efc1b26aeb14448@mail.gmail.com>
Date: Tue, 12 May 2009 09:43:47 -0700
Message-ID: <dd18b0c30905120943o3ec60f03y2dca9b95f519210a@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: Justin Mattock <justinmattock@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 8:03 AM, Bob Copeland <bcopeland@gmail.com> wrote:
> On Mon, May 11, 2009 at 6:18 PM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> Cool.
>> Another odd thing Ive experienced as well
>> with 2.6.29-rc8 is if my iphone is
>> connected to the router I'll have a hard time connecting
>> to anything until I disconnect the iphone
>> from the router.(my guess is the router is getting
>> old).
>
> So the iphone causes problems when connecting from another machine
> with ath9k, but it works ok in other kernels, or when iphone is not
> connected?  It could be related to power saving.
>
> --
> Bob Copeland %% www.bobcopeland.com
>

The setup I have is one router(netgear cheap but
works)
with macbook pro, imac, and an iphone. I guess I'm an
apple groupie, minus the OS!!
(two dells also, that I'm going to bring back from the
dead when I get a chance).

With 2.6.29-rc8 I've noticed this twice
the first time about a month ago.
basically I turned on the macbook
had the radio streaming, as well as T.V.
then a few seconds later all connections
died on the macbook, then after freaking
out I decided to reset the router, but still
system runs(macbook) and then everything
dies. Then freaking out for the second time,
I decided to shut everything off of the router
except the macbook, and voila no problem streaming.
Then after about ten minuets of non interruption
I turned the iphone wireless back on, and bam
the macbook had a dead connection again.
(leaving me dazed and confused, and that's without
any liquid propulsion).
The second time with the same kernel
was about a few days ago, but this time
after resetting the router, shutting everything
off except the macbook, and then turning the
iphone back on seemed to run fine.(leading me
to believe something might be wrong with the
router).

As for 2.6.30-rc4 not sure, still need to
get the wireless running smoothly, and then
I'll go from there.


-- 
Justin P. Mattock
