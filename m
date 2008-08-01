Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYHAWKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYHAWKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYHAWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:10:04 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:54420 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYHAWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fs77/ytFa6XQGj/QUgBueb7BSS+H1dDcWRq5ojZoCKcovMZM6AHOXWavs72rIm0DNs
         ShHLM7QAxaExEK5nqLO92eSRzh8Syi6UKIyyRnkbFLzao1fIMpWx8TURCB2VVUbB1Gfm
         4u/lxpuzUuXBloii9hp1iBSMQ2nEF2sVloDa4=
Message-ID: <86802c440808011510v535278c7oebbaf75453dcf05b@mail.gmail.com>
Date: Fri, 1 Aug 2008 15:10:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 2:30 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Aug 1, 2008 at 1:46 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:

>> http://lkml.org/lkml/2008/7/10/532

so using rcu to get irq_desc.

YH
