Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZAPSVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZAPSVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZAPSVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:21:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZAPSVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:21:38 -0500
Message-ID: <4970D04C.9080104@zytor.com>
Date: Fri, 16 Jan 2009 10:22:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com> <496F0796.76E4.0078.0@novell.com> <20090115085728.GA28607@elte.hu> <496F6DFC.90006@zytor.com> <49708423.76E4.0078.0@novell.com>
In-Reply-To: <49708423.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> If so, what would be the difference between HIGHMEM4G and HIGHMEM64G in
>> that case at all?
> 
> For example being able to select the DMADEVICES config option.

WTF?!  Why would DMA device support be banned on HIGHMEM64G?  That makes 
no sense whatsoever...

	-hpa
