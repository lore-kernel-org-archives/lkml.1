Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYHTQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYHTQAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYHTQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:00:38 -0400
Received: from gw.goop.org ([64.81.55.164]:52947 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYHTQAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:00:37 -0400
Message-ID: <48AC3FA4.9080603@goop.org>
Date: Wed, 20 Aug 2008 09:00:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging
 request"
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik>	 <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>	 <48AB5D17.5030600@goop.org> <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
In-Reply-To: <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> Sure, as everything to help debugging this :)
> http://bugzilla.kernel.org/attachment.cgi?id=17330
>   

Thanks, but could you post the *full* dmesg output, including the added
lines?  I want to see the other things it prints around there.

That said, I don't see anything unexpected in here.  It would be
interested to compare to the E820 map.

Also, what kind of machine is this?  Oh, Vaio. Hm.  Have you checked to
see whether there's an updated BIOS?  How much memory does it have
installed?

    J
