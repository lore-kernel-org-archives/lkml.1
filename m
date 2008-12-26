Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYLZRrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYLZRrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 12:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYLZRrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 12:47:24 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39725 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752657AbYLZRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 12:47:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aiXaczCCLpw0nYMHakV7C+as7ngGycF1m+8bGlNCmCTTXamRNaPelob5Vomfr6dDit7hAbCd1Ffk4ZKCJlUS8Qnwt99cEJAP7qZZWO5AxqAExsthOEzcVcQhsNc1u//H3kt7i0QBOv0TeCM3qOrMvyhiuCYOOSKAxr2W9aqUyuE=  ;
X-YMail-OSG: WzSGGawVM1nbFGhf_66.Zdgc7yJVytqzIFkRk_E33L6DxmAOuL654AFgEpTTl50ki7yd9NsMgcTjASmYwf9CtDHV.7vx7oMYPk4pZRMcB0TmNGGHSXVZJ.wYEGUAF8BXOGQNHEIVtLrX9OZ5raX4GJRNosBZiVfICWzDbIbKlExwtczA0BNgvmZH1VW5MahyA9vDjZ25UrODvmZezE1pKXLn443sid0Ujwwc.oSIlQhnZdec7uZbCJSMkC1G
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: Re: MMC: Add 8-bit bus width support
Date: Fri, 26 Dec 2008 09:47:21 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812260947.21672.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am not aware of mmc cards having 8 pins yet.

Transcend seems to have one that's reasonably available;
NewEgg has the 4GB card for $US 9.50, and Transcend sells
it direct too (at least in the US).  I'm a bit curious
what read rates they achieve ... likely not 50 MB/sec!

The relevant search keyword seems to be "MMCplus".

A third use for 8-bit bus widths is the CE-ATA.org stuff
(ATA over MMC) ... I'm not sure how real that is, but the
Seagate website has two "Lyrion" products of 30MB and 60MB
using 8-bit MMC for small disks.  I had thought bigger
drives had been announced (e.g. from Samsung, 200+ MB);
maybe they're visible only through OEM channels.

- Dave

