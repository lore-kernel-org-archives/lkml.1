Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbXIIJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbXIIJUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXIIJUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:20:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:50154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXIIJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VqwSkeuxWofQluwxONsZfg5PR34tbkCgfLITMJtV7FGwfu6dc8B2hIqbsa0gTFLLQEBktGVI7PCk0fEAzakYdG03+2DZ271ksxsSBURTp67ziVZwmGuKfLOMxHQ4r95jF5YoeD7F1OmqkUauLzRZ3BkC8/rTqo125+Pmyebo7Yw=
Message-ID: <46E3BAD1.4080709@gmail.com>
Date: Sun, 09 Sep 2007 11:20:17 +0200
From: Maciek Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-2?Q?Micha=B3_sed?= <sedmich@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, htejun@gmail.com, hmh@hmh.eng.br,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <838f88840708051433k6deed4bdg8d411e79c629ca49@mail.gmail.com> <6bffcb0e0709080832o30fb21b5vcd09baa8387efcc0@mail.gmail.com> <200709082329.57811.rjw@sisk.pl>
In-Reply-To: <200709082329.57811.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
>> Shutdown is completely broken on HP NX6??? laptops.
> 
> It's not completely broken, it just handles disks incorrectly and we are not
> sure whether or not there are any serious consequences of that.  Moreover,
> it has happened for a long time now, AFAICT, so that's not a regression.

Maybe it isn't regression, we can call it no matter how, but this issue
can shorten disk live.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
