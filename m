Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177Ab0AQQal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0AQQal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265Ab0AQQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:30:41 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:56370 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0AQQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:30:40 -0500
Message-ID: <4B533B33.5030800@pardus.org.tr>
Date: Sun, 17 Jan 2010 18:30:43 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable-review@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/9] 2.6.31.12-stable review
References: <20100114224848.GA532@kroah.com> <4B520D98.7030202@pardus.org.tr> <20100117032319.GA27413@kroah.com> <4B5335CA.7080309@pardus.org.tr> <20100117161853.GA31781@kroah.com>
In-Reply-To: <20100117161853.GA31781@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>> Personally I really don't like the idea of "all users should really be
>> moving to .3x" which is true for individual bleeding edge users which
>> compiles and uses their own kernel but there are still distributions
>> around (as well as the one that I'm trying to maintain the kernel
>> part) which ships 2.6.31.
> 
> Distros can easily add additional patches to their kernel if they wish
> to keep the .31 kernel alive longer.  I am only one person, and can not
> maintain 3 different kernel trees and remain sane.

Yep I know, that's what I'm doing, I just want to make people aware of the problems. I somehow feel a little
bit guilty if I don't report some problems that I've spotted as downstream.

You're totally right, the maintenance of 1 kernel tree would be enough messy and time-consuming, I can't
even think about 3 trees..

> 
> You aren't the first to think that .31 would be a "long term" kernel.  I
> have never stated this, and I wonder where that rumor came from.

Well I thought that .29 would be that lucky one, and .30, and .31. Not something that I
heard from anyone :)

> 
> Yes, I will be maintaining the .32 kernel in a "long-term" manner.  I
> have mentioned it before to a number of people, but don't know if I've
> done any "official" announcement.  Things get lost in the lkml volume at
> times.

That's nice to hear about that.

> 
> Ok, to help you solve this issue, I will be willing to do one more .31
> release after this one.  Just send me the git commit ids of the patches
> you wish for me to include, and I will do so.
> 
> Sound good?

No that's not necessary at all. I didn't write that to push you for another release.
I just wanted to share my ideas and got reasonable answers from you.

Thanks again.
Ozan
