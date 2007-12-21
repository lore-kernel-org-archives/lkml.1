Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbXLUPAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbXLUPAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXLUPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:00:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXLUO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:59:59 -0500
Message-ID: <476BD4E2.6080903@redhat.com>
Date: Fri, 21 Dec 2007 09:59:46 -0500
From: Bhavana Nagendra <bnagendr@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tcamuso@redhat.com
CC: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       Prarit Bhargava <prarit@redhat.com>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca> <476B185D.3000409@redhat.com> <476B19FD.7090504@redhat.com>
In-Reply-To: <476B19FD.7090504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Camuso wrote:
>> Robert Hancock wrote:
>>
>> First off, I would like to see confirmation from the horses's mouths 
>> here (namely AMD, ServerWorks/Broadcom, and whoever else) that there 
>> is no other way to get around this problem than disabling MMCONFIG 
>> for accesses behind those chips.
>>
>>
>
> And here are the excerpts from that page of the spec which are salient
> to the present discussion:
>
> ----------------------------------------------------------------------
>
> The base configuration space of the AMD-8132 and PCI(-X) devices 
> attached to it are accessible using only
> the mechanism defined in PCI 2.3. Registers of PCI-X Mode 2 devices 
> attached to the AMD-8132 in the
> extended configuration space are not accessible. The AMD-8132 has no 
> registers in the extended
> configuration space.
>
> Fix Planned
> No
>
>
Prarit, Tony et al, this is as official as it gets.   It's pretty 
clearly stated.

Bhavana
