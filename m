Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYLLRMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYLLRMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYLLRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:12:30 -0500
Received: from lucidpixels.com ([75.144.35.66]:35469 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbYLLRM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:12:29 -0500
Date: Fri, 12 Dec 2008 12:12:27 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.27.8: OOM killer: [swapper: page allocation failure]
In-Reply-To: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812121211580.5119@p34.internal.lan>
References: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Dec 2008, Justin Piszcz wrote:

> Kernel: 2.6.27.8
>
> I have a RAID-6 volume with 6 disks:
> mdadm --create -v /dev/md0 --level=6 -n 6 -e 0.90 /dev/sd[e-j]1
>
> While it is building...

Removed the extra disks, put them in another host but thought it was an
interesting bug.? so sent it to the list.

Justin.

