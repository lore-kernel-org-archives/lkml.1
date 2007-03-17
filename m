Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXCQNte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXCQNte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965548AbXCQNte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:49:34 -0400
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]:42040 "EHLO
	swarthymail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965539AbXCQNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:49:33 -0400
Date: Sat, 17 Mar 2007 10:49:28 -0300
From: John Coppens <john@jcoppens.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
Message-Id: <20070317104928.db4185f3.john@jcoppens.com>
In-Reply-To: <20070316203415.GK22466@csclub.uwaterloo.ca>
References: <20070316154735.6de11eca.john@jcoppens.com>
	<75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com>
	<20070316171253.2014deaf.john@jcoppens.com>
	<20070316203415.GK22466@csclub.uwaterloo.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 16:34:15 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> I also have noticed that many fast
> (16x) DVD writers must have an 80 wire cable or they won't work
> correctly and do nasty things to the system.

That was the problem! This is the first machine I bought assembled, 
and I hadn't noticed that the CD/DVD cables were the old 40 wire
cables. I do hope this is the last of the problems.

Thanks guys! Changed the cable, and speed went up from 3.3 to 19MB/s
(probably limited by the older harddrive too)... Thas was spectacular!
Of course, now DMA didn't switch off either.

Cheers,
John
