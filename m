Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYKDQxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYKDQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYKDQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:53:14 -0500
Received: from www.fortsev.de ([92.51.130.57]:34551 "EHLO www.arkibott.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbYKDQxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:53:14 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 11:53:13 EST
Message-ID: <49107CAA.4020704@arkibott.de>
Date: Tue, 04 Nov 2008 17:47:38 +0100
From: ray <ray@arkibott.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Add Skein hash algorithm variants
References: <20081102161506.GA21940@havoc.gtf.org> <gelgt9$7fk$1@taverner.cs.berkeley.edu>
In-Reply-To: <gelgt9$7fk$1@taverner.cs.berkeley.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> Jeff Garzik  wrote:
>   
>> This is the first draft of the Skein hash algorithm that was recently
>> mentioned, as a prominent submission to NIST's SHA-3 competition.
>>     
>
> Adding Skein to the kernel makes no sense, from a cryptographic point of
> view, at this point in time.  The appropriate point would be after it
> has been analyzed and vetted by crypto experts over a period of time.
> I suspect even the designers of Skein would advise you not to use the
> algorithm until other cryptographers have had a chance to examine it and
> it has been subjected to cryptanalysis over a period of time.  The same
> goes for all new submissions to the NIST competition.
>
>   
The final date is by the end of 2012. It's still some time until then.
http://csrc.nist.gov/groups/ST/hash/timeline.html



