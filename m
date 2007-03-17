Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXCQAOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXCQAOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 20:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXCQAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 20:14:06 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42636 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752381AbXCQAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 20:14:05 -0400
Message-ID: <45FB31F7.5050109@aitel.hist.no>
Date: Sat, 17 Mar 2007 01:10:31 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Luming Yu <luming.yu@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2 hangs my opteron during bootup, ACPI?
References: <20070307201915.4d579113.akpm@linux-foundation.org> <45F54E04.40302@aitel.hist.no> <3877989d0703120625w4afbf197qa30b62bac3cdfcf5@mail.gmail.com> <200703121556.03845.lenb@kernel.org>
In-Reply-To: <200703121556.03845.lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> On Monday 12 March 2007 09:25, Luming Yu wrote:
>   
>> try acpi=off please.
>>     
Ok, it boots up fine with acpi=off.
Now the next step is to try without the mm patch?

Helge Hafting
