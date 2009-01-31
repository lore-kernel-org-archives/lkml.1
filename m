Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZAaBHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZAaBHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZAaBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:07:21 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:53011 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbZAaBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:07:20 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=LX5mF77iWnzTCaBOVZ8A:9 a=UBUhSmw45EAA6y72ZMwA:7 a=1OooVtODaukeqjxCXH1kSaib-VsA:4 a=bTQ0lUVTahoA:10 a=HeHm-OZDlfkA:10
Message-ID: <4983A446.5080809@shaw.ca>
Date: Fri, 30 Jan 2009 19:07:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Bartosz SKOWRON <getxsick@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata - anomaly performance with NCQ
References: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com>
In-Reply-To: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartosz SKOWRON wrote:
> Hi,
> 
> here is a problem:
> http://ata.wiki.kernel.org/index.php/Known_issues#Seagate_harddrive_performance_anomaly_with_hdparm
> 
> and my disk is affected by this one as well.
> it's ST9320421AS and you can add it to the list
> 
> And 2 questions:
> 1) cause the title contains "with hdparm"...does it mean that
> physically the performance is OK and only hdparm shows something
> wrong?

Well, hdparm is a fairly crude benchmark but there's likely at least 
some impact in other usage.

> 2) there is an information about upgrading firmware. as far as i know
> Seagate doesn't publish firmwares. So the only way is to contact
> seagate support, send the hdd and wait for the new one?

I think Seagate can provide firmware updaters for the user to use, but 
normally only if you contact support I think.
