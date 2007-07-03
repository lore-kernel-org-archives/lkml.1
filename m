Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbXGCVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbXGCVnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbXGCVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:42:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbXGCVmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:42:53 -0400
Date: Tue, 3 Jul 2007 14:42:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: 2.6.22-rc7: known regressions with patches
In-Reply-To: <20070703213614.GA29175@atjola.homenet>
Message-ID: <alpine.LFD.0.98.0707031441480.9434@woody.linux-foundation.org>
References: <468A7D24.3040004@googlemail.com>
 <20070703213614.GA29175@atjola.homenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jul 2007, Bj?rn Steinbrink wrote:

> On 2007.07.03 18:45:24 +0200, Michal Piotrowski wrote:
> > Subject    : OProfile issues
> > References : http://lkml.org/lkml/2007/6/12/207
> > Submitter  : Stephane Eranian <eranian@hpl.hp.com>
> > Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
> > Patch      : http://lkml.org/lkml/2007/6/12/392
> >              http://lkml.org/lkml/2007/6/20/275
> >              http://lkml.org/lkml/2007/6/20/276
> > Status     : patches were suggested
> 
> Andi said that one of the regression fixes wasn't critical for .22 and
> that he wants to do a stopgap for the other regression (my patch
> sucked), reverting the code to the .21 version. So you can drop the
> patches and/or me here.

Can you say which patch should be reverted. This thing really shouldn't 
have gone on this long, I would have hopef we had the oprofile thing 
sorted out already..

		Linus
