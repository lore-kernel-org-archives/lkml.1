Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbXK3SUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbXK3SUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbXK3SU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:20:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXK3SU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:20:27 -0500
Message-ID: <4750545A.2030605@zytor.com>
Date: Fri, 30 Nov 2007 10:20:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [PATCH] Documentation/Changes -> Documentation/Requirements
References: <20071130071647.GA2017@ff.dom.local> <200711301747.lAUHlDdM006716@tazenda.hos.anvin.org> <alpine.LFD.0.9999.0711301256520.7197@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711301256520.7197@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>> +
>> +Kernel Compilation Requirements
>> +===============================
>> +
>> +On all systems, minimal requirements (see below for additional notes):
>> +
>> +o  Gnu C                  3.2                     # gcc --version
>> +o  Gnu make               3.79.1                  # make --version
>> +o  binutils               2.12                    # ld -v
>> +o  Gnu bc                 1.06                    # bc -v
> 
> you need bc?  for what?  i just did a defconfig build for x86 with no
> need for bc.
> 

The whole motivation for this was to get a place to document that a 
previous patch uses bc.

>> +o  Perl                   5.6.0(?)                # perl -v
> 
> if you mention perl, you should also mention sed and awk, no?  and
> perhaps suggest running scripts/ver_linux.

Please submit patches.

	-hpa
