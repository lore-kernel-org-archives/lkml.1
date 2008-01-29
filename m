Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbYA2Qg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbYA2Qg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYA2Qgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:36:45 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:43714 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYA2Qgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:36:44 -0500
Date: Tue, 29 Jan 2008 11:36:42 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479F507A.1030203@rtr.ca>
To: Mark Lord <liml@rtr.ca>
Cc: Florian Attenberger <valdyn@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Message-id: <200801291136.42612.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801291004.12565.gene.heskett@gmail.com> <479F507A.1030203@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Mark Lord wrote:
>Gene Heskett wrote:
>>..
>> Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' number
>> when dmesg says its found ok at ata2.00?  I've turned on an option that
>> says something about using the bios for device access this build, but I'll
>> be surprised if that's it. :)
>
>..
>
>It should show up as /dev/scd0 or something very similar.

Tisn't.  Darnit.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
clock speed
