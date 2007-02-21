Return-Path: <linux-kernel-owner+w=401wt.eu-S1423114AbXBUVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423114AbXBUVNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423124AbXBUVNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:13:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:63449 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423114AbXBUVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=X8aM4Jo95jWkp6gD6uSdwkHDsjRaDK5uqDV3Rz3SvLN8uJsSAP9iJGVo++dPiWmgyWowRnVoYLG/RqilJsid3lVcs1y5E76X28BfiIaKxc5idKiXwoBlKVT/BBLTjlN9o/mY41i5PghNZiRJPpyhVo+nm0DQ5OvrfXxet4Yj1Rk=
Message-ID: <8d158e1f0702211313m4bf85628t419627f7bf096281@mail.gmail.com>
Date: Wed, 21 Feb 2007 22:13:01 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [SKY2] Does anyone have this driver working?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

And now, for something completely different, no libata ;-)

I was wondering if any of you ever got the sky2 driver working
(gigabit network card found in most Siemens E laptops).

Which kernel I am trying, 2.6.17-gentoo (the kernel on the install
CD), 2.6.20, the latest gits, nothing works. It either tells me "Link
not ready" when bringing the interface up or it just gives massive
time outs.

Then, after literaly 6 reboots, it might get a DHCPACK, work, till the
next reboot, then same story all over again.

Any clue towards module settings or patches are welcome,

At the moment I am compiling Jeff's netdev upstream-linus.


Patrick
