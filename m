Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbYETP5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbYETP5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbYETP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:57:43 -0400
Received: from visualserver.org ([84.242.66.126]:40712 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYETP5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:57:42 -0400
Date: Tue, 20 May 2008 17:57:37 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: Benoit Boissinot <bboissin@gmail.com>
cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
In-Reply-To: <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805201753430.25485@visualserver.org>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> 
 <1211229736.5915.86.camel@brick>  <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
  <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com> 
 <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
 <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: CCFBE2FB42.6F3BA
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Benoit Boissinot wrote:

> On Tue, May 20, 2008 at 5:25 PM, Soumyadip Das Mahapatra
> <kernelhacker@visualserver.org> wrote:
>> Thanks for giving a reply Akinobu :-)
>> I forgot that bitrev8() is static in header file. Sorry for that.
>>
>> Below is my new patch considering this. Cant it be applicable?
>> Please review it.
>>
>> I know that my bitrev8() takes more instructions than that
>> of yours. But we have to think about faster access of cpu cache over that
>> of memory cache(which your bit_rev_table uses).
>
> I didn't review your patch, sorry.
> But I'm pretty sure that your patch won't be considered unless you
> provide benchmarks
> with numbers for different CPU/architecture.
> Ideally you should provide a script to test the correctness and the
> performance of your
> change that anyone could run on his computer.

Thanks Benoit for giving me such a precious advice. But sorry, I dont
have any benchmarking system in my hand(how can i have? i am just a
student, not a professional).
So if you do me a favour and kindly do it for me, please :-)

Anyway thanks again.

Soumya

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

