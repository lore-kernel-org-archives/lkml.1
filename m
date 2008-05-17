Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYEQTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYEQTjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYEQTjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:39:11 -0400
Received: from arx.rabbit.us ([76.244.88.238]:34911 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYEQTjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:39:10 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 15:39:10 EDT
Message-ID: <482F3201.9080908@rabbit.us>
Date: Sat, 17 May 2008 21:29:05 +0200
From: Peter Rabbitson <rabbit+list@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: David Lethe <david@santools.com>
CC: LinuxRaid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Mechanism to safely force repair of single md stripe w/o hurting
 data integrity of file system
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Lethe wrote:
> I'm trying to figure out a mechanism to safely repair a stripe of data
> when I know a particular disk has a unrecoverable read error at a
> certain physical block (for 2.6 kernels) 
> 
> <snip>
> 
> As such, anybody up to the challenge of writing the code?  I want it
> enough to paypal somebody $500 who can write it, and will gladly open
> source the solution.  
> 

Damn, here goes $500 :) Unfortunately the only thing I can bring to the table 
is a thread[1] about a mechanism that would fit your request nicely. Hopefully 
someone will pick this stuff up and make it a reality.

Peter

[1] http://marc.info/?l=linux-raid&m=120605458309825
