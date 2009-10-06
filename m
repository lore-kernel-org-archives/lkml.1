Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZJFRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZJFRZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZJFRZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:25:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60366 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923AbZJFRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:25:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ACB7C56.6070806@s5r6.in-berlin.de>
Date: Tue, 06 Oct 2009 19:20:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <4ACB626C.8090503@s5r6.in-berlin.de> <20091006170846.GA9277@elte.hu>
In-Reply-To: <20091006170846.GA9277@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Ingo Molnar wrote:
>>> One option would be to make LOCALVERSION_AUTO compulsory.
>>>
>>> Or to add a tweak to the naming, something like:
>>>
>>>  v2.6.31
>>>  v2.6.31+
[...]
>> everybody who commits to a tree from which Linus pulls from would have 
>> to base their branches onto those ...+ commits, always.
> 
> I think you misunderstood - the + would just be a shortcut for the 
> long-form precise version string.

Yep, 7 minutes later I would have seen your other post from which it
became clear even to me that it's not about magic commits but a kbuild
tweak. :-)
-- 
Stefan Richter
-=====-==--= =-=- --==-
http://arcgraph.de/sr/
