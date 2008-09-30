Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYI3TRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYI3TRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYI3TRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:17:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:13662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYI3TRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=NRz+LhRQH6HdBq2G30yK0jdz08D3AIdfPXgEcYJUAtDBq1bFvRYvvhltVn9xCRlugQ
         7NVJIL/kNY+UqfSC3Ma2ub/rwGsw89u3duVpCLC3zYwYXP3fnE0T+wk0EgYC44/01LuR
         uvBQWoXXu9D8EfMDty4XwdAYy0rdzRq3Vrhfg=
Date: Wed, 1 Oct 2008 00:47:11 +0530
From: Rabin Vincent <rabin@rab.in>
To: Andrew Lyon <andrew.lyon@gmail.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org missing .1 incremental patches
Message-ID: <20080930191710.GA2477@debian>
References: <f4527be0809301151k66277093gd5303e73df6d834e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4527be0809301151k66277093gd5303e73df6d834e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 07:51:00PM +0100, Andrew Lyon wrote:
> The incremental patches at
> http://www.kernel.org/pub/linux/kernel/v2.6/incr/ seem to be missing
> all .1 patches, for example there are patches to take 2.6.25 from
> EXTRAVERSION = .2 to .17 but no patch for .0 > .1, attempting to apply
> patch-2.6.25.1-2 to 2.6.25 will fail on the Makefile as it does not
> have the correct starting version.
> 
> I assume the patches are generated from a script and there is a bug,
> easily worked around by downloading the full 2.6.25.1 tarball but the
> full incremental set would be very useful for a project I am working
> on.
 
There are no incremental patches for .0 -> .1 in incr because those
would be the same as the patch-2.6.xy.1.bz2 patches available at
pub/linux/kernel/v2.6/.

Rabin
