Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYFLFcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYFLFcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFLFbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:31:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:12645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYFLFbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TMqZXqNUIdcvkNFOmtSsDcsJ9wcaJZc1YoneYTATUSo380RBFVDgC4uniyiz+1c4bB
         0kSjcXvxhl2Xx5S3Qvv5p3k8vbcbF1hUJy4wPrH4vn6R2XEl82AjGlZuIuQlHrUGZNpT
         deS1GxB9roczIaOSFe8saMLU6tirMYbKd8KBg=
Message-ID: <19f34abd0806112231m69bd521fgbce3c5f8dd413423@mail.gmail.com>
Date: Thu, 12 Jun 2008 07:31:47 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Linux Power Management List" <linux-pm@lists.osdl.org>,
       "Lin Ming" <ming.m.lin@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 12, 2008 at 1:44 AM, Len Brown <lenb@kernel.org> wrote:
> please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>
> This will update the files shown below.

What about the "ACPICA: Fixes for Unload and DDBHandles" patch?

http://bugzilla.kernel.org/show_bug.cgi?id=10669

The patch was reverted in mainline, but is now fixed, shouldn't it be
brought back at some point? It's (still) listed as a regression,
anyway.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
