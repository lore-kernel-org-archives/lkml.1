Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYKYXzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYKYXzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYKYXzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:55:31 -0500
Received: from smtp139.mail.mud.yahoo.com ([209.191.107.122]:37233 "HELO
	smtp139.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750974AbYKYXzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:55:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 18:55:30 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-Id:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=zo2846SlqTmniuz/6NzO2aU9Zc8XsoC5M3ypvahtiVgkiLuJiOCn7DMB6QfAfp7uJjZFMIUBBM2fZXj/jfQm325yZwYwuL6yZoBe1e1kkuG8DQnjbD+0OQKpifGNoLx5RnqwYi/0No6U2+nw54NaQ1reDkD70Ak3HZ0bf3brcY0=  ;
X-YMail-OSG: BpURaewVM1mYTZABZ8DYjUgeHUzz.ymniD5aYrEOs_56IEEDVNgI2oQGvHHNrGU5XJRZktan3CdNEORylkgu_UEas6_iML2D1GYl_oOl.nQVepfxoGBYHTi1UhkpmGtn08zDMaXzdhGAtib_WydhQ2t7
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] fix similar typos to successfull, v2
From: Fernando Carrijo <fcarrijo@yahoo.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081125145308.8633bf4a.akpm@linux-foundation.org>
References: <492AE7ED.8040304@suse.de>
	 <20081125145308.8633bf4a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 21:49:13 -0200
Message-Id: <1227656953.18268.13.camel@pc-fernando>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 14:53 -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2008 01:44:13 +0800
> Coly Li <coyli@suse.de> wrote:
> 
> > When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
> > in kernel tree, 22 typos found totally --  great minds always think alike  :)
> 
> Mutter.  I have a super-strict (lol) policy of "I don't take patches
> which fix typos/spellos in comments", because we have so many such
> errors, and I'd get buried in silly patches.  But I do take patches
> which fix documentation and user-visible printks, etc.

Since you started the thread, I feel less guilty to talk about the
existence of tons of another kind of typo spread around the kernel
sources: null statements created by duplicated semi-colons at the end of
statements. Something like foo();;

Cheers,
Fernando


