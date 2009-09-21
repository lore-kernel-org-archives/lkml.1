Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZIULT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZIULT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZIULTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:19:54 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:51208 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZIULTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <20090921083724.GA27357@n2100.arm.linux.org.uk>
References: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
	 <20090921083724.GA27357@n2100.arm.linux.org.uk>
Date: Mon, 21 Sep 2009 14:19:57 +0300
Message-ID: <cc557aab0909210419x795d407erfc07ad0f4550ed88@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ARM: Introduce ARM_L1_CACHE_SHIFT to define cache 
	line size
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 11:37 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Sep 12, 2009 at 11:48:30PM +0300, Kirill A. Shutemov wrote:
>> Currently kernel believes that all ARM CPUs have L1_CACHE_SHIFT == 5.
>> It's not true at least for CPUs based on Cortex-A8.
>
> Please send this to the patch system.  There's no need to add the "V2"
> comments to it when you do.
>

#5716, #5717

BTW, I ,my pathes without change log in your git tree. Commits 910a17e
and dca230f. What is wrong with it?
