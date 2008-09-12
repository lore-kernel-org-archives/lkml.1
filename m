Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYILUOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYILUOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYILUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:13:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYILUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:13:51 -0400
Message-ID: <48CACD68.4050006@zytor.com>
Date: Fri, 12 Sep 2008 13:13:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>	 <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
In-Reply-To: <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> to see how wrong could be set by BIOS.
> 

I'm starting to think that all this dumping of ACPI information needs to 
be put under a command-line option.

	-hpa
