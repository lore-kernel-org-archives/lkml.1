Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYBPK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYBPK1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYBPK1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:27:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:47988 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYBPK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KEfqxcfTZ2are8Lv0Xd12KJAhgCIRFHFBR1f4LlOxicpzDjmsPAq5wR48KeOy3n4UUsycS2NRWpQLRwEIt6eACcirdJX9MAZPjvxfo/CuZJz7fBuf53MhFD7B9I07c5nR+5tMozjRU0B4nrhjPBQfivvrv7szsIVzVfNUM+cfUs=
Message-ID: <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com>
Date: Sat, 16 Feb 2008 12:27:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
Cc: "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andy Whitcroft" <andyw@uk.ibm.com>
In-Reply-To: <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de>
	 <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de>
X-Google-Sender-Auth: 4d80b15f832a31b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 16, 2008 12:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> People, who do cleanups - I'm not talking about running lindent here -
> read through the code while they fix it up.
>
> Actually they find bugs that way or at least come up with useful
> questions about code which is not obvious in the first place.
>
> Discouraging such cleanups with a pretty offensive warning is
> counterproductive.

Well, it's not just about cleanup patches submitted by "newbies". I
use checkpatch for development too and the warning is real PITA for
that.
