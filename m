Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbXJYW0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbXJYW0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXJYW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:26:07 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49726 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752997AbXJYW0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:26:06 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 01:26:48 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Kleen, Andi" <ak@suse.de>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710250744420.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710260126.48885.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thursday 25 October 2007 Tarihinde 17:55:00 yazmıştı:
> I think the OpenBSD people decided to actually do something about this,
> and I suspect it had *nothing* to do with license issues, and everything
> to do with these kinds of problems. I wish them all the luck, although
> personally I think LLVM is a much more interesting project.

And on the LLVM side all hopes for clang [0] at least for better C++ error 
reporting ;-)

[0] http://clang.llvm.org/

-- 
Faith is believing what you know isn't so -- Mark Twain
