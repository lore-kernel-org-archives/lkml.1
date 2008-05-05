Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYEETde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYEETde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYEETd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:33:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:27577 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYEETdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NKHoWSNTozzN/fTH/1ctg6jJciUeLqY/9RyNRbYnVEVfBr7vic7Pd8mBePZxhDs2LtwggiVT2HXWZtIw/YtRopDlLlqKWyTM3aH4ovc0CBortzmHLXsCjW7fw1AgFONudJwGuoZRR3Arw5cKuFQ9pdwgTrkW06aW+2QoFZP2jhE=
Message-ID: <30c6373b0805051233o25b45762w2eb6f72591fae3dd@mail.gmail.com>
Date: Mon, 5 May 2008 12:33:23 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "FD Cami" <francois.cami@free.fr>
Subject: Re: Ability to limit or disable page caching?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
X-Google-Sender-Auth: 69434d7a437999b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.
>> /proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
>> what you are looking for.
>
> I haven't played with vfs_cache_pressure so I'll take a look at this.
>
> Unfortunately, swappiness doesn't work as intended.

OK....... I tried again and no such luck unfortunately.

Set vfs_cache_pressure to 0 and 200 (default is zero) and no luck either way.

A value of 0 us used for swappiness ....

Any other ideas...

The box has enough memory to do this as I can run it without swap....

Kevin

-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
