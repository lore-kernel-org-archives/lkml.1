Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZKQAwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZKQAwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZKQAwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:52:34 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:37813 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZKQAwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:52:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ic3bJ/1v2YJeach1wxIytZv6ZeLoG3d14gGlDdHXGpHmoMYY3NeNHcv7OFpYvre7yt
         +wG5F8SWByy8/bXNS0JPJv/BPbisXBeEURRY0jOg+q/8v+l1SS78dvthYUvEP3/2BlhZ
         D47Re8lf/mUf0/isxYXmOxPosHDRS4GMSlFOY=
Message-ID: <4B01F3FE.8040707@gmail.com>
Date: Mon, 16 Nov 2009 16:53:18 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera> <OWmO9uyC1hM.A.yiC._ndALB@chimera>
In-Reply-To: <OWmO9uyC1hM.A.yiC._ndALB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> Subject		: Disassociating atheros wlan
> Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> Date		: 2009-09-24 10:16 (54 days old)
> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
>
>
>
>    
I'm not sure(I've been procrastinating on this one
with reverting commits to see if it helps
the guy that reported this).

 From over here though there never was a problem
on my side with the wireless connection(maybe a few disconnects,
but nothing too harsh).

At this point the best thing to do is to see what the
response is from the two gentlemen who where really
hitting this and seem to be running into issues
then go from there.

Justin P. Mattock


