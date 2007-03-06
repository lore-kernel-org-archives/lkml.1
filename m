Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbXCFMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbXCFMx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933874AbXCFMx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:53:57 -0500
Received: from lucidpixels.com ([75.144.35.66]:58661 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933842AbXCFMx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:53:56 -0500
Date: Tue, 6 Mar 2007 07:53:56 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, r.marek@assembler.cz
Subject: Intel chooses not to support its HECI/QPS Chip in Linux?
In-Reply-To: <Pine.LNX.4.64.0702050553080.29175@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0703060752390.29188@p34.internal.lan>
References: <Pine.LNX.4.64.0702041050170.14035@p34.internal.lan>
 <1170655334.3073.1227.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702050553080.29175@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Justin Piszcz wrote:

>
>
> On Mon, 5 Feb 2007, Arjan van de Ven wrote:
>
>> On Sun, 2007-02-04 at 10:57 -0500, Justin Piszcz wrote:
>>> Hi,
>>> 
>>> Anyone from Intel that reads LKML, could you provide an update as to what
>>> is happening with support for your HECI Controller/QPS chip, which is used
>>> on 965 (and possibly other?) chipsets.
>> 
>> I asked the right folks and the word I got was "Soon". The code we have
>> needs some major cleanups before it's suitable for lkml posting... but
>> it'll be there soon. We're working on the cleanups full time.... We'll
>> send an update when we're further along
>> 
>
> Very good news, thanks for the update!
>
> Justin.
>

It has been > 1 month since this last e-mail, I was wondering if anyone in 
the community [or Intel] could provide an update?  I spoke with one of the 
lmsensors the other day and he stated that there may be a plan to 
incorporate the CPU temperature soon, depending on what Intel does/what 
they provide.

Are we any closer to getting full HECI support in the kernel today than 
last month?

Justin.
