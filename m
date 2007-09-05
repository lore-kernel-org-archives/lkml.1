Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbXIERbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbXIERbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbXIERb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:31:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:55539 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbXIERbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:31:25 -0400
Date: Wed, 5 Sep 2007 13:31:24 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Andreas Schwab <schwab@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: modinfo <modulename> question
In-Reply-To: <jesl5tuj41.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0709051331190.22864@p34.internal.lan>
References: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
 <jesl5tuj41.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1231663185-1189013484=:22864"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1231663185-1189013484=:22864
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 5 Sep 2007, Andreas Schwab wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
>> Is there anyway to get/see what parameters were passed to a kernel modul=
e?
>
> /sys/module/<module>/parameters
>
> Andreas.
>
> --=20
> Andreas Schwab, SuSE Labs, schwab@suse.de
> SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
> PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED=
5
> "And now for something completely different."
>

And under 2.4?

Justin.
---1463747160-1231663185-1189013484=:22864--
