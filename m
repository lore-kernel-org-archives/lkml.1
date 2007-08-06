Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbXHFTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbXHFTLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760951AbXHFTLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:11:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:37527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbXHFTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:11:38 -0400
In-Reply-To: <200708021214.51705.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708011002.30962.m.kozlowski@tuxland.pl> <18096.24918.111376.805855@cargo.ozlabs.ibm.com> <200708021214.51705.m.kozlowski@tuxland.pl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e2ac1b1e51999a427fc2567071577f11@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linuxppc-dev@ozlabs.org, linux-usb-devel@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Mon, 6 Aug 2007 21:10:52 +0200
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2 aug 2007, at 12:14, Mariusz Kozlowski wrote:

>>> Second issue as reported earilier allmodconfig fails to build on 
>>> imac g3.
>>
>> Do you really mean g3?  If so it's a 32-bit kernel and it shouldn't be
>> building lparmap.s.

It might be a bug nevertheless, there are more "issues" with
the interesting way lparmap.s is built and used.


Segher

