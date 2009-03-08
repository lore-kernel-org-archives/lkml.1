Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567AbZCHHmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbZCHHmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 03:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZCHHmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 03:42:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:59940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZCHHmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 03:42:46 -0400
Subject: Re: AMD 64 Box is not able to boot with latest -tip
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49B31909.9020407@kernel.org>
References: <1236441089.3285.6.camel@localhost.localdomain>
	 <49B31909.9020407@kernel.org>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 13:12:17 +0530
Message-Id: <1236498137.2807.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Sat, 2009-03-07 at 17:02 -0800, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > My AMD 64 Box was not able to boot with latest -tip and kernel is
> > dumping.
> > 
> > Because of hot weather and not proper cooling I cannot debug the problem
> > so only thing I can tell is:
> > 
> > BAD : cb553adb4e83bc
> > 
> > Good : f0ef03985130287c6c
> > 
> 
> You realize you left absolutely no usable information in that post, I
> hope... not a single bit of detail about the system other than it having
> an AMD CPU.

Oops, I have send my configs file and other related info various times
to LKML and Ingo.

Anyhow now I made a git tree for it ;)

http://git.kernel.org/?p=linux/kernel/git/jaswinder/kernel-cfgs.git;a=summary

Thanks,
--
JSR

