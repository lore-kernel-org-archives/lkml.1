Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYH3VNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYH3VNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYH3VNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:13:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:52465 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYH3VNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bMVp1LtSOxYMNfoz/+7AOrwKKH7jLGjdQdPJNcvXiMsVIRZVjaacQGcEbYQQtPgZ3R
         FAjLl1p4aXVQNpy22z0h3JlnYXYxecdsgpyBbi1tqTL5OEpy02RLTRRDOQABlunBOsCi
         1sVjNhQIBVqcjKObrtmUTJIuHaVJ1b+O9auRY=
Message-ID: <86802c440808301413g7f496e8bxd21adc60b328cd24@mail.gmail.com>
Date: Sat, 30 Aug 2008 14:13:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <86802c440808301412k4e0b5562ie03ce41547ddab9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
	 <86802c440808301338h59a5338rabe9e64560b55476@mail.gmail.com>
	 <200808302246.48199.rjw@sisk.pl>
	 <86802c440808301412k4e0b5562ie03ce41547ddab9a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 2:12 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Aug 30, 2008 at 1:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Saturday, 30 of August 2008, Yinghai Lu wrote:
>>> please check
>>>
>>> [PATCH] x86: split e820 reserved entries record to late v4
>>> [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
>>
>> What kernel should I apply those to and in what order?
>
> linus git tree
> 1. [PATCH] x86: split e820 reserved entries record to late v4
> 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
>
> tip/master
> 1. Resource handling: add 'insert_resource_expand_to_fit()' function
> 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6

actually it is almost the same to tar ball send you for your system...

YH
