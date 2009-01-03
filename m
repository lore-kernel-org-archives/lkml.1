Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZACTww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZACTww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbZACTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:52:43 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3565 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbZACTwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:52:42 -0500
Date: Sat, 3 Jan 2009 20:51:30 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>,
       Dave Jones <davej@redhat.com>
Subject: Re: ath9k microwave anomaly
Message-ID: <20090103195115.GA31855@vanheusden.com>
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com> <495EDC10.20605@gmail.com> <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com> <495EE2A0.2080703@gmail.com> <495EEE1D.8050500@shaw.ca> <20090103073051.GC5038@1wt.eu> <495F1DA3.7060706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495F1DA3.7060706@gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Thu Dec 25 11:53:05 CET 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> BTW, having any WiFi stopping working at 30 feet around a microwave oven
>> makes me think that beast is leaking like mad. I've already ran experiences
>> with mine in the past, and it could only slightly perturbate the traffic
>> within one meter (3 ft) which I already considered huge. You may want to
>> try to put some aluminium foil on the front door, it is possible that the
>> protection grid is damaged or not properly sealed.
>>
> great!!
> (should I build a cement barrier?);
> I had timeouts like this with the wireless phone
> (then went out a bought an encrypted phone for this purpose);

Since a few months my wifi connections dropped during the day and sometimes
at nights well. So I took my laptop with the WiSpy dongle and went for a
walk in the neighbourhood. Found out that outside there's fresh air that
feels really good to your nose and also that one of my neighbours has a
wireless security camera which he occasionally switches on during the day.
(weblog entry: http://vanheusden.com/misc/blog/2008-12-11-wifi.php ).

> now the microwave is causing the same issue.(silently though);
> like what I had mentioned, the microwave causes this when
> it's cold started, making wonder if the waves are better handled
> when the metal or grate is warm as opposed to cold.
> (molecules are jumping around as opposed to moving around);
> in any case as long as that microwave isn't active the internet
> connection seems O.K.(knock on wood);

There are devices with which you can measure the leakage of a micro-
wave (which should not be more than 50 watt per m^2 on a distance of
5 cm; read that at http://members.lycos.nl/return/mgnetron.htm ).
Iirc conrad.nl has these.


Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
