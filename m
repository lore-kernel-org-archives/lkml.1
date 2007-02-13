Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXBMIbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXBMIbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXBMIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:31:43 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:18409 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXBMIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:31:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OyEKJ4txT8ctypy55jxOEZlIebU+uoUjSOVSyCBYU9t3sK2GnPYBGvVMBXO19Jek3pcLjCsyUonedL6kKoTkF77/il5Jb3n5P7odKLvP42WknvAzQnH0B2iL+rFPc1PxHIkQZ+3TxxvDXs3UXSDZCparSGl5g77b2XX0XNruYY0=
Message-ID: <8d158e1f0702130031n75926241q83733cceb4080aa9@mail.gmail.com>
Date: Tue, 13 Feb 2007 09:31:41 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: libsata tests started
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0702101423xd854b59x22d1d08f89ffa42c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>
	 <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
	 <20070210203504.129b35ac@localhost.localdomain>
	 <8d158e1f0702101232q244a890fg450aa039689fcb3a@mail.gmail.com>
	 <8d158e1f0702101404s457fd1fx72f838021d7831b7@mail.gmail.com>
	 <6bffcb0e0702101423xd854b59x22d1d08f89ffa42c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So, my AMD Athlon XP2400+ with pata_pdc2027x, pata_sil680 and pata_via
survived four days of bonnie++, emerge -e world, dd if=//dev/random
of=/tmp/whatever, and most of all, four days of me :)

SO I guess it's safe to assume I didn't find any weird things by using
2.6.20 and the new libata drivers.

Now, since functionality by design is boring and my employer doesn't
torture me enough,, I' pulled the libsata-dev git and linux-2.6 git
and will see how that goes.

Tests on my Siemens laptop are still in progress, since i have to
reboot to windows every day (cooperate rules at work, network
authentication, yadayada).

I didnt have time yet to install Linux on my HP Pavilion dv8373 and on
my Dual P2 400Mhz with Intel 440BX motherboard, but I hope to do this
soon.

Have a joyfull day and i hope you have better weather than we have
here in Amsterdam.


Patrick Ale
Not even the best coder can -Dsense -Dsane me
