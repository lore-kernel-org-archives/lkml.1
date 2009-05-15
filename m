Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZEOWKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZEOWKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZEOWJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:09:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:35435 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbZEOWJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eObdn7htfGR9mQyXVwKwckVlHVQ1id6WZRGhMtisHE7Vx6lDnaRkVirie5sxExTUHB
         AaX1HyzERopr5uGKJSMYYFIC57dwjZqIdsiQv5/Pcu3ql/Y8v57FhVdp6OHmg67p+o3g
         19HZyCUySPJzxiOGjRJ7hPG4yMD84wakdShQ4=
MIME-Version: 1.0
In-Reply-To: <84144f020905151342w3565e8bcq4c6e7397e6c802b@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
	 <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
	 <84144f020905151342w3565e8bcq4c6e7397e6c802b@mail.gmail.com>
Date: Sat, 16 May 2009 00:09:59 +0200
Message-ID: <56e1b5710905151509t3b15e75dv115a064534c0f39a@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:42 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Fri, May 15, 2009 at 4:28 PM, Floris Kraak <randakar@gmail.com> wrote:
>> Quite honestly I still believe just disabling this check is the best
>> thing to do.
>
> Agreed. The proposed "fixes" to silence the warning don't improve the
> code and apparently in some cases they even increase kernel text.
>

The exercise needed to be done to prove the point though ;-)

Regards,
Floris
---
'Or lawyers may say, “But if I decline, someone else will do it. So
what is gained?” My reply: “Let someone else do it. But not you. Honor
is personal. Worry about yourself.  You don’t get a pass from moral
responsibility because you acted for a client.”

That’s the first lesson I would offer, aimed at lawyers. A second
lesson, aimed at all, is this: Keep ready your capacity for outrage.
This is very important. Next to the vote, outrage is the one response
each of us can contribute. Outrage is how honor must confront
dishonor. If we lose the capacity for outrage, we are in serious
trouble. '
   --- Stephen Gillers
