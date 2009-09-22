Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZIVRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZIVRj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZIVRjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:39:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZIVRjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:39:24 -0400
Message-ID: <4AB90AC3.20908@zytor.com>
Date: Tue, 22 Sep 2009 10:34:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v4 4/4] Use macros for .data.page_aligned section.
References: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>	 <1253484855-8067-5-git-send-email-tabbott@ksplice.com> <1253576808.7103.167.camel@pasglop>
In-Reply-To: <1253576808.7103.167.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Sun, 2009-09-20 at 18:14 -0400, Tim Abbott wrote:
>> This patch changes the remaining direct references to
>> .data.page_aligned in C and assembly code to use the macros in
>> include/linux/linkage.h.
>>
>> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>

Acked-by: H. Peter Anvin <hpa@zytor.com>
