Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXLDVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXLDVf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXLDVfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:35:47 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:5447 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXLDVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=r2xvjH640THe3xevzZE+wiunMmfMEF0nHy9a9XGpzClT+TLDclsqR/Ta74FSJPVp9FDPRY5C4sBWOB0+QDogQ0PYsBuAFlbDbGp4z3DUNT/tINWrhv8T4TSclXtn+2uH2jH1Rcaq8rbkxM3LP8Q+yajA8Iii7Qubq+dwAk+KKuI=
Message-ID: <4755C82D.40903@gmail.com>
Date: Tue, 04 Dec 2007 16:35:41 -0500
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gregory Haskins <ghaskins@novell.com>, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] RT balance v7
References: <20071204204236.3567.65491.stgit@novell1.haskins.net> <20071204212705.GA10360@elte.hu>
In-Reply-To: <20071204212705.GA10360@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> Ingo,
>>
>> This series applies on GIT commit 
>> 2254c2e0184c603f92fc9b81016ff4bb53da622d (2.6.24-rc4 (ish) git HEAD)
> 
> please post patches against sched-devel.git - it has part of your 
> previous patches included already, plus some cleanups i did to them, so 
> this series of yours wont apply. sched-devel.git is at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git


Ah, will do.  Thanks!

-Greg
