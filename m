Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZEJV0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZEJV0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZEJV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:26:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZEJV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Xbc54ZvmOBMLQ3e0yB6EXLpPnDspvTEBA1wsQ9i5RAXJ6t9pa/6kOCG5s2Pqs2JpHd
         xdsv5L8+wVPM3N3qRPvn6LZuEAs92dVBisePultgYWPSJQAPWWjAnaxiD7i1Rm4a7moN
         GqQe52RNdfnv4NKbgPvlzLPv1QbJctXIb+XY4=
Message-ID: <4A074682.6010403@gmail.com>
Date: Sun, 10 May 2009 23:26:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops in wireless from today's git
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
In-Reply-To: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2009 09:39 PM, Chris Clayton wrote:
> I've just done a git pull and built, installed and booted the kernel.
> Unfortunately I got the oops below.

What's your HEAD? Looks like the issue solved by
0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
