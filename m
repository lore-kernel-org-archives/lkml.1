Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXIBAV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXIBAV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932545AbXIBAVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:21:22 -0400
Received: from barikada.upol.cz ([158.194.242.200]:46424 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbXIBAVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:21:21 -0400
To: Willy Tarreau <w@1wt.eu>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [OT] good job guys with the anti-spam !
In-Reply-To: <20070731214011.GA17735@1wt.eu>
References: <20070731214011.GA17735@1wt.eu>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 2 Sep 2007 02:36:18 +0200
Message-Id: <E1IRdRq-00015P-S4@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tue, 31 Jul 2007 23:40:11 +0200
>
[]
> eventhough people often write only when they have something to complain
> about, I for once would like to congratulate Matti and David, our mail
> admins, for the wonderful job they've done with the spams lately. This
> month, I might have seen maybe one or two instead of perhaps 30 per day
> earlier. While it did not bother me that much earlier, I can say that
> the list is more pleasant to read every day, and I think that's great.
>
> Kudos guys !
>
> Willy
>
> PS: please do not start another one of those long useless threads from now on
>

Instead let me share an idea and see what will happen (if any).
The mailing list policy:

1. sent mails must have in-reply-to (rfc2821 SHOULD) with valid, i.e.
   existing in archives, message-id;

2. otherwise sender gets response about creating new thread. Replying
   to that message will enable (1).

I don't know how performance of ever increasing anti-spam
rules/software grow vs message-id lookup will be affected.

Gmane shows good performance on load, which is times bigger than LKML's.
News server requires unique ids, so...

Ah, if spammers will become smart and will reply with appropriate headers
set up, everything will fall apart.

Finally. What i see:
* no spam,
* big patch-bombs in one thread (easy to skip)
* more order, if useless/obsolete footers removed, but such info is
  sent in (2).

* easy blacklisting if rules are not obeyed since day X

  Oh, no, don't say we value bug reports. Reports must be organized in
  other way, one of which i've described as development tracking system.
  Such e-mail policy is unavoidable part of this it. E-mail is everything
  it requires. Of course some html, css, javascript, perl guys will be
  free to implement any web-face they like. But story if git-web have
  something to learn instead.
--
-o--=O`C
 #oo'L O
<___=E M
