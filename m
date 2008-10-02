Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYJBAWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYJBAWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYJBAV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:21:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34873 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYJBAV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:21:58 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=tXlxjq5k84GmiRTJgn4A:9 a=bmcgZc2hmi4Y71kTggmuRHvRjK4A:4 a=32DFYXIcfAgA:10 a=igSbEetJFJEA:10
Date: Wed, 01 Oct 2008 18:21:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: How to make all of 4GB of memory available?
In-reply-to: <fa.LzFGkHEK7iy88LF74OslLpTs7d0@ifi.uio.no>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <48E41426.9060006@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LzFGkHEK7iy88LF74OslLpTs7d0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> New mobo, 4 core AMD Phenom cpu & 4 GB of dram.  I cannot find the switch in a 
> make xconfig that will allow use of all of it, I am only seeing 3GB.
> 
> Am I going blind in my dotage?
> 
> Thanks.
> 

HIGHMEM64G. Or better yet, use a 64-bit kernel.
