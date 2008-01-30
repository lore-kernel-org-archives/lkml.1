Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYA3ATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYA3ATz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYA3ATo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:19:44 -0500
Received: from rtr.ca ([76.10.145.34]:3116 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYA3ATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:19:43 -0500
Message-ID: <479FC29A.1000207@rtr.ca>
Date: Tue, 29 Jan 2008 19:19:38 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       Richard Heck <rgheck@bobjweil.com>,
       Daniel Barkalow <barkalow@iabervon.org>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801291204.44671.gene.heskett@gmail.com> <20080129185445.1c7d3a83@core> <200801291741.50192.gene.heskett@gmail.com>
In-Reply-To: <200801291741.50192.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
>
> I doubt libata has that capability now, or ever will, cuz these ide/atapi 
> devices are generally dumber than rocks about that.  But any device claiming 
> to be scsi-II is supposed to be able to do those sorts of things while the 
> cpu is off crunching numbers for BOINC or whatever.
..

The CD/DVD drives all all "MMC" devices internally, which means they speak
a SCSI command protocol.  Regardless of the electrical or optical interface.

Linux is software, and the software protocol is exactly the same for them,
no matter what the cable/bus type happens to be.

Cheers
