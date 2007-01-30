Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXA3UXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXA3UXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXA3UXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:23:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXA3UXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=MEl0bwwHugEuhkYuFbE9UaN9Wt46j9FVxUUNNeM8Wcb9Pd8zkxNj4S755Dhd7QUjkGmCUCS0jCTCQvdHPZH/5TEoGl8SdCaRYODHQWX1/L576CFLow5DVSjq8ge9Vdravd2bKtdG9be7jKmSomLbxlBjWQiSaQVwNdkLHpVd3uI=
Date: Tue, 30 Jan 2007 21:23:34 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-Id: <20070130212334.2a042fdf.diegocg@gmail.com>
In-Reply-To: <Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com>
	<Pine.LNX.4.61.0701301151350.23321@yvahk01.tjqt.qr>
	<20070130191405.GI20642@kroah.com>
	<Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 30 Jan 2007 20:31:01 +0100 (MET), Jan Engelhardt <jengelh@linux01.gwdg.de> escribió:

> Don't they claim 50+? Already browsing 
> ftp://ftp.de.netbsd.org/pub/NetBSD/NetBSD-3.1 gives more than 2 
> screenfuls [à 25].

I don't know exactly how many architectures does netbsd run, but Linux seems
to support arches that netbsd doesn't, like: 64 bit MIPS, PPC 970 (available in
netbsd but not yet integrated i think), Cell, S390, M32R, Nec v850, frv, cris?,
xtensa, mmuless cpus (apparently there're lots of mmuless cpus), Itanium
(netbsd development ongoing)

Sure, Linux doesn't support vax and the like, but it does support lots of
architectures that matter. In  http://netbsd.org/Ports/#ports-by-cpu there's a
more Linux-like view of the architectures supported. Although Netbsd people
will argue that porting a architecture to Linux is more difficult and that Linux
gets support just because there's a lot of $$$ around it.

Anyway, even if Linux wasn't the OS with more architectures supported
it'd be the _second_ on the list. Which is quite impressive anyway, and
nothing to be ashamed of.






