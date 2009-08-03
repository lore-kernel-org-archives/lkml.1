Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZHCSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZHCSjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZHCSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZHCSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:39:43 -0400
Message-ID: <4A772ED0.70208@zytor.com>
Date: Mon, 03 Aug 2009 11:39:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add quirk to make Apple MacBook5,2 use
 reboot=pci
References: <19062.56420.501516.316181@cargo.ozlabs.ibm.com> <tip-1961b971360c685e15dff59929c39ced6c46e171@git.kernel.org> <4A772105.6060101@pardus.org.tr>
In-Reply-To: <4A772105.6060101@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 10:40 AM, Ozan Çağlayan wrote:
> 
> MacBookPro5,1 has also this problem. I booted with reboot=pci on
> 2.6.30.4 and now it rebooted without problem.
> That would be nice if you could add another quirk entry for it:
> 
> System Information
>         Manufacturer: Apple Inc.
>         Product Name: MacBookPro5,1
> 

Please write, test, and send a patch to do this.

	-hpa
