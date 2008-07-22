Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYGVUzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYGVUzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYGVUzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:55:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:60023 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYGVUzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:55:05 -0400
Date: Tue, 22 Jul 2008 16:55:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
In-Reply-To: <1216736883.7257.102.camel@twins>
Message-ID: <alpine.DEB.1.10.0807221654480.11681@p34.internal.lan>
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan> <1216736883.7257.102.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jul 2008, Peter Zijlstra wrote:

> On Tue, 2008-07-22 at 10:21 -0400, Justin Piszcz wrote:
>> Hello,
>>
>> To be able to utilize 128 GiB of memory on a host, does one need to enable
>> NUMA support? Currently only 64 GiB is showing up.
>>
>> As far as machine name/motherboard type, I do not have this information
>> currently but I am told there are one or two of these boxes are running
>> CentOS 5.x and/or RHEL5/AS.
>
> Sounds like you need to bug RH with that ;-)
>
>> Is there something special you need to do to utilize all 128 GiB of
>> memory?
>
> Does a recent kernel work for you? Also, you could at the very least
> have mentioned your machine architecture; is it x86_64, ia64 or ppc64?
>

Sun X4600, will find out if they are running the right kernel and also 
check the BIOS, thanks.

Justin.
