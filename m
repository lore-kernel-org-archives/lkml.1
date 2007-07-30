Return-Path: <linux-kernel-owner+w=401wt.eu-S966996AbXG3RFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966996AbXG3RFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXG3RFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:05:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:50617 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbXG3RFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:05:04 -0400
Message-ID: <46AE1A4A.4030909@qumranet.com>
Date: Mon, 30 Jul 2007 20:05:14 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1, KVM-AMD problem
References: <200707281855.41277.alistair@devzero.co.uk> <200707291510.31731.alistair@devzero.co.uk> <46ADE0DD.1030505@qumranet.com> <200707301800.55671.alistair@devzero.co.uk>
In-Reply-To: <200707301800.55671.alistair@devzero.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Monday 30 July 2007 14:00:13 Avi Kivity wrote:
>   
>> How about the attached patch? (I haven't yet tried to reproduce, but
>> this can cause an AMD-only oops).
>>     
>
> This seems to have fixed the problem. Thanks Avi.
>
>   

Excellent.  I'll submit this fix for 2.6.23.


-- 
error compiling committee.c: too many arguments to function

