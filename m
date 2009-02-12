Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZBLJQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZBLJQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 04:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZBLJQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 04:16:03 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51097 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZBLJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 04:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ts3knbDbtvJghmQoJfb8NEjAm3AX7likkOcLrTBbQ5rv0l396WK6DC47dONEsu45cY
         1AaJRevZ0x6gKbrGMDoGKGhjLu7FpJaS4w9hgc3K37I7TKsi0kI3m1d4UZhp26+g8a0S
         tT7sgmO3UKlzZHFtj1GOb7asHfmrXfb9vACUI=
MIME-Version: 1.0
In-Reply-To: <20090212085814.GA1386@ucw.cz>
References: <20090204184029.881610776@mini.kroah.org>
	 <20090204184654.GH25246@kroah.com> <20090210202429.GC1382@ucw.cz>
	 <20090210205752.GA3044@suse.de> <20090212085814.GA1386@ucw.cz>
Date: Thu, 12 Feb 2009 10:15:57 +0100
Message-ID: <71cd59b00902120115y31ba350dtbf3d785bd84cdb9@mail.gmail.com>
Subject: Re: [patch 33/41] asus-laptop: Fix the led behavior with value > 1
From: Corentin Chary <corentin.chary@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > "= !!value" is standard  way to do that.... for unsigned value.
>>
>> No dispute here, but that's what is upstream :)
>
> No dispute there, I just hope original author fixes it in the upstream
> on one sunny day :).

I'll fix that, but currently it's rainning =)


-- 
Corentin Chary
http://xf.iksaif.net
