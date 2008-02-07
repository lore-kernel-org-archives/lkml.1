Return-Path: <linux-kernel-owner+w=401wt.eu-S934839AbYBGVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934839AbYBGVMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbYBGUyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:11 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:46804 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbYBGUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:08 -0500
Message-ID: <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
Date: Thu, 7 Feb 2008 13:54:06 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
Cc: "Jiri Slaby" <jirislaby@gmail.com>, stephen.neuendorffer@xilinx.com,
       linux-kernel@vger.kernel.org, "Paul Mackerras" <paulus@samba.org>,
       "Kumar Gala" <galak@gate.crashing.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080207124203.147ce300.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB6552.7040503@gmail.com>
	 <20080207124203.147ce300.akpm@linux-foundation.org>
X-Google-Sender-Auth: 379a57e64e909464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 07 Feb 2008 21:08:50 +0100
> How it got from there into Linux is also a mystery.  I see a batch of
> powerpc updates just went into mainline but I don't know whose tree was
> pulled - I wasn't copied on any pull request and I can't find one on the
> kernel mailing list.
>
> Perhaps Paul has just done a stealth merge, but the patch to which you
> refer doesn't have his signoff.  Very confused.

It went through my tree.  Paul pulls from Josh Boyer's tree for
powerpc-4xx patches, and Josh pulls from mine for xilinx virtex
powerpc 405 patches.

My screw up, sorry I broke the rules.  What is the best way to resolve this?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
