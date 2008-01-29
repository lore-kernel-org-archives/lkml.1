Return-Path: <linux-kernel-owner+w=401wt.eu-S1765151AbYA2QMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765151AbYA2QMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763002AbYA2QMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:12:46 -0500
Received: from rtr.ca ([76.10.145.34]:1337 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYA2QMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:12:45 -0500
Message-ID: <479F507A.1030203@rtr.ca>
Date: Tue, 29 Jan 2008 11:12:42 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Florian Attenberger <valdyn@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801281413.21347.gene.heskett@gmail.com> <20080129074127.5699afcf.valdyn@gmail.com> <200801291004.12565.gene.heskett@gmail.com>
In-Reply-To: <200801291004.12565.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
>..
> Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' number 
> when dmesg says its found ok at ata2.00?  I've turned on an option that says 
> something about using the bios for device access this build, but I'll be 
> surprised if that's it. :)
..

It should show up as /dev/scd0 or something very similar.

