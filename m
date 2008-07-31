Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbYGaWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbYGaWHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYGaWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:07:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:1431 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbYGaWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gj+l/xlzYV0QC0uLgQzfgW1lSips9ZzttXnpS/Whg56Q752lEPZWHecSqjPeAHFteN
         ER7CAeasPjM9fHETou+i9lFn6+OC0yK9q/7u6rFa3CEbWNegwm1K0sLBDSiqdj2FSXPo
         1iTe/ueksoqYPasxPOjazzycw5UjdkKj/4AE8=
Message-ID: <86802c440807311507n50e2d029j8942c24dbca23ebe@mail.gmail.com>
Date: Thu, 31 Jul 2008 15:07:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH 0/3] dyn_array support #2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, benh <benh@kernel.crashing.org>
In-Reply-To: <1217541108.8157.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291414.55479.yhlu.kernel@gmail.com>
	 <200807300311.48510.yhlu.kernel@gmail.com>
	 <200807301210.31511.yhlu.kernel@gmail.com>
	 <200807302109.21519.yhlu.kernel@gmail.com>
	 <1217541108.8157.108.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 2:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2008-07-30 at 21:09 -0700, Yinghai Lu wrote:
>> please check the patches adding dyn_array and nr_irqs #2
>
> Why can't we use a radix tree like powerpc does?
>
which file in arch/power i could look?

YH
