Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZIDOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZIDOK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZIDOK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:10:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:32211 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbZIDOKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v+ydoyjtcttCZG0a1eJCYDY6kzLoNpbsz3CrPr0Msr0AXrmuGh+xVZqZ0/hP+4Ws4P
         VK8Mk+xCY4nwfuWpPFlOppkGQSges8friSN7/wF+ziBFf5DO6vimb6JPeyzkBIzgNKiR
         2vNAGpmzlRQ3IsOM9e5dbXj1zN/eJwAPKPaA4=
MIME-Version: 1.0
In-Reply-To: <200909041223.22835.oliver@neukum.org>
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
	 <200909030907.02321.oliver@neukum.org>
	 <20090903160536.GA24050@kroah.com>
	 <200909041223.22835.oliver@neukum.org>
Date: Fri, 4 Sep 2009 16:10:56 +0200
Message-ID: <8db1092f0909040710t5c048e93j3fb5adc9e7f1cf6a@mail.gmail.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/4 Oliver Neukum <oliver@neukum.org>:

>
> Maciej,
>
> can you run a git bisection?
>
>        Regards
>                Oliver
>
>

I run one bisection, but result may not be correct. I try again on
another machine (which has the same problem).

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
