Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZKBRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZKBRcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZKBRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:32:18 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:58797 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbZKBRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S/2LcrDwNxj0sTAiaDHGyknutQDcVDOMGWUK61ZitIOtGotmbpCMtYRDmiddKBteKM
         0cJaFZQYfyFG5IONeziNGF7l9nnlZrfV8TT8bKQHrWgpdF25qso77qoAyXZzMNTtxpKu
         0JKcZwySePwKVM26uhgPf/CN84Co93AkX8LG0=
MIME-Version: 1.0
In-Reply-To: <20091102170114.GE14046@tuxdriver.com>
References: <1256886023.3555.5.camel@johannes.local>
	 <20091030110616.GB6150@ff.dom.local>
	 <20091030150223.GA2586@tuxdriver.com> <20091102091038.GA9044@elte.hu>
	 <1257153807.3555.173.camel@johannes.local>
	 <20091102100702.GA16963@elte.hu>
	 <20091102170114.GE14046@tuxdriver.com>
Date: Mon, 2 Nov 2009 17:32:18 +0000
Message-ID: <efe7343f0911020932l21a570c8u9478568329d38e2c@mail.gmail.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
From: Luis Correia <luis.f.correia@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[huge snip]

This is going to be my last reply to this thread (even if I get to be insulted).

I'm not a coder, I'm a tester and administrator for the rt2x00 project.
I'm not happy about the current state of the rt2x00 in-kernel drivers.
I tend to agree that more could be done.

Even though I'm not a coder, I could be hipotetically responsable for
the current situation. It is my job function to motivate people to
work on the rt2x00 in-kernel drivers, but apparently I've failed here.
It's not an atitude problem, as some have suggested, it's just life.

About Bartlomiej, there is only one more thing that I'll say:

I've searched on my GMail archives and the only patch Bart has
provided so far for the rt2x00 project is this:

[PATCH] MAINTAINERS: rt2x00 list is moderated

Which, while technically correct, adds nothing to the project.

So, I will personally continue to ignore Bart's comments, regards and
rants, until he provides patches for rt2x00 that actually make the
driver better.

Luis Correia
rt2x00 project admin,
(but not writing this email as an official project statement)
