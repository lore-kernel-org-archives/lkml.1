Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbYBAMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbYBAMRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYBAMRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:17:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:49703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYBAMRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:17:16 -0500
To: "Jike Song" <albcamus@gmail.com>
Cc: "Rijndael Cosque" <rijcos@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What's the status of x2APIC support in Linux kernel?
From: Andi Kleen <andi@firstfloor.org>
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
	<df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com>
Date: Fri, 01 Feb 2008 13:17:14 +0100
In-Reply-To: <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com> (Jike Song's message of "Fri\, 1 Feb 2008 16\:53\:31 +0800")
Message-ID: <p73fxwc50s5.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jike Song" <albcamus@gmail.com> writes:

> On 2/1/08, Rijndael Cosque <rijcos@gmail.com> wrote:
>> Hi all,
>>
>> I found the x2APIC spec via http://www.intel.com/products/processor/manuals/.
>>
>> Looks at present there is no x2APIC support in Linux kernel 2.6.24?
>>
>> Is there any experimental patch available for Linux kernel? -- I
>> googled "x2APIC Linux";  looks no patch for now?

There are right no CPUs shipping which implement x2apic.

> Maybe.   I have a question as well, what about the  status of I/O
> xAPIC support in linux?  If it is not supported yet, is there any
> effort to add it?  I'm interested in that, hopefully can take part in
> the development.

xAPIC has been supported forever.

-Andi
