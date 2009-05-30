Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZE3WnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZE3WnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZE3Wju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:39:50 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62869 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbZE3Wjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=M5Bji+B/0f591SHbjyfG0uRC1ZRB0L8V61zJZO1KSDDOL5zyVitRO4RgpTyEtOM7ot
         yR6/B4szJSdSWg44E7gpBh8zXZBXICocAtHVGBwFMrirrC+aaBsWBeYCnBNJ9jYMC6BA
         uZn2XOFgZ9+TenLVGKc4PZfSDqeFFXs/28aN4=
Date: Sun, 31 May 2009 00:39:41 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13362] [mac80211 ] Wifi Network Slownes Bisected
Message-ID: <20090531003941.4891c859@varda>
In-Reply-To: <LEcEO2518_I.A.9zD.8IbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	<LEcEO2518_I.A.9zD.8IbIKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 30 May 2009 21:37:34 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> escribió:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).

 It should be listed.

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject		: [mac80211 ] Wifi Network Slownes Bisected
> Submitter	: Alejandro Riveira <ariveira@gmail.com>
> Date		: 2009-05-22 13:32 (9 days old)
> 
> 
