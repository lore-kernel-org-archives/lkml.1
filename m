Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXH3HLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXH3HLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXH3HKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:10:53 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:42229 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbXH3HKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:10:53 -0400
Message-ID: <46D66D49.20300@l4x.org>
Date: Thu, 30 Aug 2007 09:10:01 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Adrian Bunk <bunk@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org> <20070829234734.GA26410@stusta.de> <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 30 Aug 2007, Adrian Bunk wrote:
> 
>> Christoph, is your fix in -mm suitable for 2.6.23, or how else should 
>> this regression be fixed for 2.6.23?
> 
> Looks like this is just alpha and a certain particular compiler version? 

binutils 2.15.95, gcc 3.3.6 and I could update to 4.0.4 or something
more recent I guess. And yes, it's only alpha.

Of which file do you want the objdump?

Jan
