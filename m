Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXGKJkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXGKJkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbXGKJkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:40:35 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:47871 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757075AbXGKJkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SM5m/iDitiHEQWmC1Kb136PP+banRp8ESDF6/pMXE9fas1rJF1Xou4OTafL0pKHQXdNzujWIUDZj2oiL9TcAdjuVhghWXMz7k8WqcFixWawVUo31/zOEahZRVx3bQtSaIoy7M3xqgb4JkSrAQ7zP2KYcfvy8HY+JlF6/kxM/Dzk=  ;
X-YMail-OSG: EcJQ_kYVM1ly.zN3l7q0GsjISJPb4QZ4Xdn0wM4F8_FCELyjX2.4.vwX85hC8oscYqRd8__INA--
Message-ID: <4694A58A.8020401@yahoo.com.au>
Date: Wed, 11 Jul 2007 19:40:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Michael Kerrisk <michael.kerrisk@gmx.net>
Subject: Re: testcases, was Re: -mm merge plans for 2.6.23 -- sys_fallocate
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org> <20070710154503.GC27033@thunk.org> <20070710180531.GB8908@osiris.ibm.com> <20070710114119.d8e874a1.akpm@linux-foundation.org> <20070711093626.GB19061@infradead.org>
In-Reply-To: <20070711093626.GB19061@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jul 10, 2007 at 11:41:19AM -0700, Andrew Morton wrote:
> 
>>I'd support an ununofficial rule that submitters of new syscalls also raise
>>a patch against LTP, come to that...
> 
> 
> s/ununofficial//, please.  And extend this to every new kernel interface
> that's not bound to a specific piece of hardware.

Agree, and cc manpages maintainer too? (preferably write most
of the manpage body as well, IMO).

-- 
SUSE Labs, Novell Inc.
