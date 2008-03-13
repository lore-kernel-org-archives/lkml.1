Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYCMHF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYCMHF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYCMHFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:05:16 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59780 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482AbYCMHFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:05:15 -0400
Message-ID: <47D8D232.9050001@davidnewall.com>
Date: Thu, 13 Mar 2008 17:35:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803122317.24849.phillips@phunq.net> <47D8C9E8.6020908@davidnewall.com> <200803122350.56811.phillips@phunq.net>
In-Reply-To: <200803122350.56811.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Wednesday 12 March 2008 23:30, David Newall wrote:
>   
>> Daniel Phillips wrote:
>>     
>>>> Your idea seems predicated on throwing large amounts of RAM at the
>>>> problem.  What I want to know is this: Is it really 25 times faster than
>>>> ext3 with an equally huge buffer cache?
>>>>         
>>> Yes.
>>>       
>> Well, that sounds convincing.  Not.  You know this how?
>>     
>
> By measuring it.  time untar -xf linux-2.2.26.tar; time sync
>   

No numbers.  No specifications.  And by doing a sync, you explicitly
excluded what I was asking, namely a big buffer cache.  You've certainly
convinced me; you don't know if your idea is worth a brass razoo.

Come back when you've got some hard data.
