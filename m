Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZDNRWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZDNRWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZDNRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:22:23 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:50273 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZDNRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:22:22 -0400
Message-ID: <49E4C5BD.1040405@oracle.com>
Date: Tue, 14 Apr 2009 10:19:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain> <20090414122906.GA20201@x200.localdomain> <alpine.LFD.2.00.0904141006170.18124@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904141006170.18124@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49E4C5A1.01BA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 14 Apr 2009, Alexey Dobriyan wrote:
>>> We're not merging OpenVZ code _either_.
>> This is to give example of other prefixes: cpt_ and rst_
>> Are they fine?

http://www.rfc-editor.org/rfc/rfc5513.txt


> Do you secretly work for IBM?
> 
> IBM has a well-known disdain for vowels, and basically refuses to use them 
> for mnemonics (they were called on this, and did "eieio" as an instruction 
> just to try to make up for it).
> 
> But I'm from Finland. In Finnish, about 75% of all letters are vowels. I 
> find this dis-emvoweling to be stupid and impractical. Without vowels, you 
> can't tell Finnish words apart (admittedly, _with_ vowels, you generally 
> cannot pronounce them, so to a non-Finn it doesn't much matter).
> 
> My point is, let's go for a happy medium - LEAVE THE F*CKING VOWELS IN 
> PLACE ALREADY.
> 
> So let's call it "checkpoint" and "restore". Ok?

restart ?

-- 
~Randy
