Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZICThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZICThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZICThT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:37:19 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:42650 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZICThQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FFO8M9VG0cQ6i3+yQ2N8JJQZ+ZgpnaLM8uMJ6JYL+bIV69spV/qG/gGev3Pbe8lvAA
         hh9IOJnFTMifgzjzZp65biUksMdeSPgj956Zeo5jgoY1SbKmMcz6KO0veXTqHrMVrx9N
         ShR5hMwyhwT3t3zmrV8Rz/h0UUIwRLJUHA99A=
MIME-Version: 1.0
In-Reply-To: <1251967786.3336.19.camel@johannes.local>
References: <20090903041429.GA29875@kroah.com> <1251967786.3336.19.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Sep 2009 12:35:11 -0700
Message-ID: <43e72e890909031235t17543020leb3d19b17d955d01@mail.gmail.com>
Subject: Re: Staging tree status for the .32 kernel merge
To: Johannes Berg <johannes@sipsolutions.net>,
       Christian Lamparter <chunkeey@web.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stephen Chen <Stephen.Chen@atheros.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>       - otus.  This is sitting here until a "real" wireless driver
>>         will be merged through the wireless tree.  Hopefully that
>>         happens soon.
>
> ar9170 has been in for a while now, it's just not quite at feature
> parity yet -- however that also means otus will get no work whatsoever
> from any of the wireless folks. Draw your own conclusions. Personally, I
> would drop it and let the users figure out whether they can live with
> ar9170 or need to support work on it.

Greg, as Johannes noted otus has lacked focus as Johannes whipped out
a port for it in a few weeks and then Christian gave it some final
love taps for inclusion, we just still use otus as just a source of
documentation for any yet missing feature, but for that I guess I can
just refer people to my git tree. Chris would know better where we're
at as far as feature-parity is concerned though so I'll leave it up to
him to judge whether or not having otus gets some users anything
ar9170 doesn't yet have.

  Luis
