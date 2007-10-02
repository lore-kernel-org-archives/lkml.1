Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbXJBIKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbXJBIKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJBIK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:10:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXJBIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Lz6WmbizpfJZCxhUQgqqq4RthsqMRc9d1bqwa9dKAIKM4VfRQeiLfAR9v/0DV0x2yxxY1cFyiRhzU7NUM4gQEDCsTcSwBoKAkGaHNnH8Rce5I5Q5RxE1mhE22VgKww0X3T+Y+tziNOlnGwG8UXcFysWkBGRq7HczbG3BwueAGNM=
Message-ID: <4701FCEA.2050200@gmail.com>
Date: Tue, 02 Oct 2007 10:10:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Wireless damage [Was: -mm merge plans for 2.6.24]
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <4701FC79.3060608@gmail.com>
In-Reply-To: <4701FC79.3060608@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huh, Cc back lkml.

On 10/02/2007 10:08 AM, Jiri Slaby wrote:
> On 10/01/2007 11:22 PM, Andrew Morton wrote:
>> git-net-vs-git-wireless.patch
> 
> Hum, latest wireless-2.6?h=everything already had a proper fix when this patch
> was merged. But pull/push is stuck somewhere :(.
> 
>> git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
>> net-add-ath5k-wireless-driver-fix.patch
> 
> let it live in -mm (wireless-2.6) so far.
> 
>>   Wireless damage control.  Will see what happens.
