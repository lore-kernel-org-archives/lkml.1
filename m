Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGVUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGVUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYGVUze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:55:34 -0400
Received: from lucidpixels.com ([75.144.35.66]:39263 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYGVUzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:55:33 -0400
Date: Tue, 22 Jul 2008 16:55:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
In-Reply-To: <20080722104327.30cee9be@bree.surriel.com>
Message-ID: <alpine.DEB.1.10.0807221655140.11681@p34.internal.lan>
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan> <20080722104327.30cee9be@bree.surriel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jul 2008, Rik van Riel wrote:

> On Tue, 22 Jul 2008 10:21:44 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> To be able to utilize 128 GiB of memory on a host, does one need to enable
>> NUMA support? Currently only 64 GiB is showing up.
>
> How much memory does the BIOS say the system has?
Asked them.

>
> Can you get the e820 memory map (from early boot up) of the systems?
Probably can't get this.

>
>> As far as machine name/motherboard type, I do not have this information
>> currently but I am told there are one or two of these boxes are running
>> CentOS 5.x and/or RHEL5/AS.
>
> Hopefully not with 64GB each :))
Nope :P

>
>> Is there something special you need to do to utilize all 128 GiB of
>> memory?
>
> You need to use a 64 bit kernel, for one.
Will verify what they are running, thanks.
