Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZEXE2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZEXE2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 00:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZEXE2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 00:28:42 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:33612 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZEXE2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 00:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <1243135358.3560.1.camel@Joe-Laptop.home>
References: <cover.1243131992.git.joe@perches.com> <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com> 
	<fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com> 
	<1243135358.3560.1.camel@Joe-Laptop.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 23 May 2009 22:28:19 -0600
Message-ID: <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L: linux-kernel@vger.kernel.org 
	from all but "THE REST"
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 9:22 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2009-05-23 at 21:18 -0600, Grant Likely wrote:
>> Really?  That makes the assumption that lack of an "L:" tag is
>> equivalent to an "L:linux-kernel" tag, which IMNSHO I don't believe is
>> true.
>
> Documentation/SubmittingPatches
>
> 6) Select your CC (e-mail carbon copy) list.
>
> Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.

Is that actually true in practice?  At least on linuxppc-dev, very few
patches are cc'd to lkml.  I don't remember ever being prompted to cc
lkml on all patches, and I haven't been prompting others to do so.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
