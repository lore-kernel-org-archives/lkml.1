Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbXJZGV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbXJZGV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXJZGVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:21:51 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:40229 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXJZGVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:21:49 -0400
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Sam Ravnborg'" <sam@ravnborg.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>
Cc: <linux-kernel@vger.kernel.org>, "Jesper Nilsson" <Jesper.Nilsson@axis.com>
Subject: RE: Upcomming CRIS patches
Date: Fri, 26 Oct 2007 08:21:46 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C4011D@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680547FAFA@exmail1.se.axis.com>
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Are there access to a cross-compile chain for i386 somewhere?

Sure, that's the only way we do it (CRIS has typically too low performance
and memory to compile anything although it has been shown that it is
possible)

You can find the compiler at
http://www.axis.com/reg/login.php?oldurl=/products/dev_sdk/download_compiler
.php.
Unfortunately you have to register. 

The GCC CRIS maintainer is also very active in the GCC comunity.

Best Regards
/Mikael

-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: Friday, October 26, 2007 8:18 AM
To: Mikael Starvik
Cc: linux-kernel@vger.kernel.org; Jesper Nilsson
Subject: Re: Upcomming CRIS patches


On Fri, Oct 26, 2007 at 07:50:41AM +0200, Mikael Starvik wrote:
> Just a heads up that we will now finally start to submit CRIS patches.
> The first patches will make CRIS compile in the official tree. Further
> patches will then add functionality and correct bugs.
> 
> A new machine called Artpec-3 will also be added.
> 
> /Mikael and Jepser


Great - thanks!
Are there access to a cross-compile chain for i386 
somewhere?

	Sam

