Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXERSqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXERSqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbXERSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:46:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbXERSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:46:04 -0400
Message-ID: <464DF467.8080108@zytor.com>
Date: Fri, 18 May 2007 11:45:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
References: <E1Hp6er-0001aX-00@calista.eckenfels.net>
In-Reply-To: <E1Hp6er-0001aX-00@calista.eckenfels.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am> you wrote:
>> I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid, 
>> everest identify as D 930 (Dual Core, 3GHz). From Intel site I find out 
>> that it has no HT feature, nor Windows XP identify it as HT.
> 
> the ht flag reported by the CPU and cpuinfo is not a reliable detection if
> HT is available on your CPU or your motherboard/bios.
> 
>> Why do I have "ht" flag in cpuinfo?
> 
> Because your CPU reports it. You will see that also in cpuz output.
> 
> However, you can see ht in the sibblings value (for a single core it will be
> 2 if you have HT, I am not sure if it is 4 for a dual core CPU)

IIRC, the HT flag is also reported for multicore CPUs.

	-hpa
