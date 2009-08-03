Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZHCURy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZHCURy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZHCURy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:17:54 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:42350 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZHCURx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:17:53 -0400
Message-ID: <4A7745EF.7000300@pardus.org.tr>
Date: Mon, 03 Aug 2009 23:17:51 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add quirk to make Apple MacBook5,2 use
 reboot=pci
References: <19062.56420.501516.316181@cargo.ozlabs.ibm.com> <tip-1961b971360c685e15dff59929c39ced6c46e171@git.kernel.org> <4A772105.6060101@pardus.org.tr> <4A772ED0.70208@zytor.com>
In-Reply-To: <4A772ED0.70208@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 08/03/2009 10:40 AM, Ozan Çağlayan wrote:
>   
>> MacBookPro5,1 has also this problem. I booted with reboot=pci on
>> 2.6.30.4 and now it rebooted without problem.
>> That would be nice if you could add another quirk entry for it:
>>
>> System Information
>>         Manufacturer: Apple Inc.
>>         Product Name: MacBookPro5,1
>>
>>     
>
> Please write, test, and send a patch to do this.
>   
Okay will do that way, thanks for your fast reply.
