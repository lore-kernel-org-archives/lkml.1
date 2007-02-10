Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXBJM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXBJM1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:27:35 -0500
Received: from web50210.mail.yahoo.com ([206.190.38.51]:36047 "HELO
	web50210.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933367AbXBJM1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:27:35 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 07:27:34 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=S+Pg0KNS+IZQBKDwrv3YDv5QTzopjtQoQOG8rO9I+MHONnI4q8SqrVRfPkhkhNdaUFABVgYPWfKu1Ylfo7ImKKzy0SC2oy5Qi5HeKsluhnxa6c49GaaXUJqdSNHkVlI47J1D7gSqNrNRHLvRSBuTWfXsuvxiifuFPu098ScXSQo=;
X-YMail-OSG: UEW6GXMVM1lOQR1IdDSFWKcWvOwLLccnC8FNBSB8kyL7pb8eUEhHD5AUaUuq_zqa5fwxf_LsYGkCtO55wgTEs4AhMnr0nvg8bMInlTJqix_gMKmkQaachaGSptAlcZD.ge7qrbMOi3O345qgvPigAVDbEr0jgx66kko-
Date: Sat, 10 Feb 2007 04:20:53 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Problem of USB - error 71 : how configure kernel to dongle with chipset
To: linux-kernel@vger.kernel.org, hulin.thibaud@wanadoo.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <292704.97873.qm@web50210.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As you are using ndiswrapper, you won't much if any help from the kernel developers.
ndiswrapper taints the kernel as it links closed-source drivers into kernel space.

I strongly advise you to post this question on the ndiswrapper mailing list.

Good luck.

-Alex

> Hi !
> I'm trying to use a dongle with ndiswrapper, but it fails because a 
> problem of usb. Indeed, when I put on first the dongle, a lsusb give :
> Bus 001 Device 002: ID 0457:0163 Silicon Integrated Systems Corps.
> Bus 001 Device 001: ID 0000:0000
> But, 10 to 30 seconds later, the dongle is not recognize with an error -71.
> lsusb give :
> Bus 001 Device 001: ID 0000:0000
> How can I configure the kernel to have the good configuration ? I tried 
> different ways, but it fails.
>  
> Thanks for help,
> Thibaud.

I code, therefore I am


 
____________________________________________________________________________________
TV dinner still cooling? 
Check out "Tonight's Picks" on Yahoo! TV.
http://tv.yahoo.com/
