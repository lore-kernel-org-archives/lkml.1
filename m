Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXBJUcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXBJUcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXBJUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:32:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:63209 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbXBJUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iSQfWXyjWmrnJYzk/gg33r+W7/UgmN9/fwDPc77jnCNkX/Szejw9USzOPsv6C2zGo8+SIDMX57+MXKeeT31YMsK657j5muv8TJXHOzAYNJOTomfOxzZV1ZNjHbpKO6qlE3bEYnbtileYl23AoQsc/T8/1haHiChN1GQxTOOptrc=
Message-ID: <8d158e1f0702101232q244a890fg450aa039689fcb3a@mail.gmail.com>
Date: Sat, 10 Feb 2007 21:32:51 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: libsata tests started
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070210203504.129b35ac@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>
	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>
	 <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>
	 <20070210203504.129b35ac@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:

> Right umm "Your honor the gentleman is human, this is not acceptable" ?

Human and a looney who wishes Monty Python's Flying Circus still
existed so he could be a main character and having a great excuse to
act weird.


> Beating the crap out of it using it for real work is one excellent form
> of testing. We aren't yet at the point of only worrying about benchmark
> tuning and corner cases.

Exactly what I am doing :)
I know bonnie++ is mostly used for benchmarking, but it also is a
great tool to hammer down your hard-disks.

I also break RAID1 arrays volunteerly (spelling) and resync them to do
some stress tests on the disks, but I dont recommend others to do
these kind of tests, unless you dont worry about your data, or are a
fruitcake, like me.

Patrick
