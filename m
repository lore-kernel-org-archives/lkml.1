Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbYBBCzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbYBBCzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 21:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761088AbYBBCzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 21:55:12 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:11636 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760084AbYBBCzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 21:55:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jXgVliYh3Hgy/XB9l/8uyRIY8qrAY674JTUM4ClI/4RqJ41+HpVqHWWyb/lq20O3pzK0g8bjSWNkwJSNy1Kf/dCo3QEH54pGKwbYQnPLoK976RBvDUxG1MmhpgsWtS8q1rRXnfeEz7gnaF+JgYq10pGcIRAmBTHjuCtm+Eo/m6k=
Message-ID: <df9815e70802011855p29c10787lcee23bc9fab181d4@mail.gmail.com>
Date: Sat, 2 Feb 2008 10:55:06 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: What's the status of x2APIC support in Linux kernel?
Cc: "Rijndael Cosque" <rijcos@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p73fxwc50s5.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
	 <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com>
	 <p73fxwc50s5.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/08, Andi Kleen <andi@firstfloor.org> wrote:

> There are right no CPUs shipping which implement x2apic.
Thanks for your information.

> "Jike Song" <albcamus@gmail.com> writes:
> > Maybe.   I have a question as well, what about the  status of I/O
> > xAPIC support in linux?  If it is not supported yet, is there any
> > effort to add it?  I'm interested in that, hopefully can take part in
> > the development.
>
> xAPIC has been supported forever.

Thank you for your attention, Andi.

Oh, what do I mean is "I/O xAPIC", but not the "local xAPIC" or xAPIC
interrupt architecture introduced by Intel Pentium4 CPU.   It seems
that the "I/O xAPIC" hasn't been well documented yet, but some other
document do have some description about it.  Some Intel guys gave me
an URL for the document:

http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf

Section 5 and section 9.5 describe 'I/OxAPIC'. I'm not sure if it is
already supported by Linux, I guess it is not.

--
Best Regards,
Jike
