Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbZGaCCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbZGaCCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 22:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZGaCCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 22:02:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZGaCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 22:02:46 -0400
Message-ID: <4A725072.1000702@zytor.com>
Date: Thu, 30 Jul 2009 19:01:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: Valdis.Kletnieks@vt.edu, Frans Pop <elendil@planet.nl>,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       hirofumi@mail.parknet.co.jp, aneesh.kumar@linux.vnet.ibm.com,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <200907291519.19567.gene.heskett@verizon.net> <28783.1248957815@turing-police.cc.vt.edu> <200907301135.03509.gene.heskett@verizon.net>
In-Reply-To: <200907301135.03509.gene.heskett@verizon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2009 08:35 AM, Gene Heskett wrote:
> 
> Humm, kewl.  And the src's for grubby are where?  Hopefully in C so thois old 
> fart can grok...
> 

They're part of the Fedora mkinitrd package.  They're in C, but they'll
make you go blind.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

