Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbXJYXEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbXJYXEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXJYXE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:04:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56290 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbXJYXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:04:27 -0400
Message-ID: <472120F6.2080703@garzik.org>
Date: Thu, 25 Oct 2007 19:04:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: =?UTF-8?B?SXNtYWlsIETDtm5tZXo=?= <ismail@pardus.org.tr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Kleen, Andi" <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
References: <200710251324.49888.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org> <200710260126.48885.ismail@pardus.org.tr> <47211F19.5080607@garzik.org>
In-Reply-To: <47211F19.5080607@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Ismail Dönmez wrote:
>> Thursday 25 October 2007 Tarihinde 17:55:00 yazmıştı:
>>> I think the OpenBSD people decided to actually do something about this,
>>> and I suspect it had *nothing* to do with license issues, and everything
>>> to do with these kinds of problems. I wish them all the luck, although
>>> personally I think LLVM is a much more interesting project.
>>
>> And on the LLVM side all hopes for clang [0] at least for better C++ 
>> error reporting ;-)
>>
>> [0] http://clang.llvm.org/
> 
> Someone should take 'sparse' and use that as a C language front-end to 
> LLVM...

Among clang's "features":
	"A single unified parser for C/ObjC/C++"

bleh.  I cannot imagine how ugly a C parser gets, after being taught 
C++.  IMO since you can basically redefine everything in C++, it's not a 
language but a proto-language.

	Jeff


