Return-Path: <linux-kernel-owner+w=401wt.eu-S1163520AbXD1Spx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163520AbXD1Spx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163523AbXD1Spw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:45:52 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:49864 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163521AbXD1SpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:45:16 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 14:45:16 EDT
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <200704282022.11321.ak@suse.de>
References: <463382E5.9060701@goop.org>  <200704282022.11321.ak@suse.de>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 13:34:27 -0500
Message-Id: <1177785267.3688.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 20:22 +0200, Andi Kleen wrote:
> On Saturday 28 April 2007 19:22:45 Jeremy Fitzhardinge wrote:
> > This adds an smp_ops for voyager, and hooks things up appropriately.
> > This is the first baby-step to making subarch runtime switchable.
> 
> James, does it actually work?

It will take me a while to tell you ... would you believe I'm currently
bisecting for a voyager regression in 2.6.21 ...? ;-)

James


