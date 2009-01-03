Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbZACXkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbZACXkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbZACXkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:40:31 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45244 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060AbZACXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:40:30 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=j_fXwfwkAAAA:8 a=WCBVr2USdif67LT0x4AA:9 a=xXC5guL6EAfleTNTbWZIkoXBxAUA:4 a=-a-Xhm53yFYA:10 a=cYtf6X6zflwA:10
Message-ID: <495FF769.3040205@shaw.ca>
Date: Sat, 03 Jan 2009 17:40:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, x86@kernel.org, netdev@vger.kernel.org,
       tytso@mit.edu, eric@anholt.net, airlied@redhat.com
Subject: Re: Bug/Warning report for the week of January 3rd, 2009
References: <20090103140332.74f39ade@infradead.org>
In-Reply-To: <20090103140332.74f39ade@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Rank 2: mtrr_trim_uncached_memory (warning)
> 	Reported 420 times (9816 total reports)
> 	BIOS bug (often in VMWare) where the MTRR's are set up incorrectly or not at all
> 	This warning was last seen in version 2.6.28, and first seen in 2.6.24.
> 	More info: http://www.kerneloops.org/searchweek.php?search=mtrr_trim_uncached_memory

It would be useful if this warning dumped out some DMI BIOS information 
or something, so we could see what systems/boards this was commonly 
happening with..
