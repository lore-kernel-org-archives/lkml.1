Return-Path: <linux-kernel-owner+w=401wt.eu-S1946420AbXBQGdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946420AbXBQGdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 01:33:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946421AbXBQGdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 01:33:02 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946420AbXBQGdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 01:33:00 -0500
To: davids@webmaster.com
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
References: <MDEHLPKNGKAHNMBLJOLKKEIPBKAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 17 Feb 2007 04:32:15 -0200
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEIPBKAC.davids@webmaster.com> (David Schwartz's message of "Fri\, 16 Feb 2007 18\:59\:29 -0800")
Message-ID: <orire1s39s.fsf@free.oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> Linking with kernel exported symbols in a kernel module is by many
>> people considered creating a work derived from the kernel.

> That's simply unreasonable. It is the most clear settled law that only a
> creative process can create a work for copyright purposes. Linking is an
> automated process, not a creative process. It cannot create a work at all,
> much less a derivative work.

Per this principle, it would seem that only source code and
hand-crafted object code would be governed by copyright, since
compilation is also an automated process.

FWIW, http://www.fsfla.org/?q=en/node/128#1 touches a very similar
issue, also covered in the upcoming release of the video of the FSFLA
session in the 5th GPLv3 conference.

> If you have two works, A and B, and neither is a derivative work of the
> other, linking them together cannot change the status of A or B.

IANAL, but I understand this is correct.  However, the output is
probably a derivative work of both.

Also, it's the fact that A needs to be linked with B, or vice-versa,
that's a clue that A is likely to be a derived work from B, or
vice-versa, even before they're linked together.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
