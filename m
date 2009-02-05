Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZBEBEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZBEBEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZBEBD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:03:57 -0500
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:49827 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754481AbZBEBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:03:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=N608VHm0o9mkLVNyFlROwQ75+d6lXUIw8J39WEtfd8PjvtzLDY28igDwUuJrrSn72RoGMVm6EAuuBW9LaP/OhdW6pvDNsa7SgOuu1Y0fSHLYGpHWNJYK3pmYtpnewx2z;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug #12598] tg3 dead after resume
Date: Wed, 4 Feb 2009 17:03:52 -0800
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.QEF._uYiJB@chimera> <alpine.DEB.2.00.0902041941440.6694@parag-desktop>
In-Reply-To: <alpine.DEB.2.00.0902041941440.6694@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041703.54330.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 4, 2009 4:43 pm Parag Warudkar wrote:
> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12598
> > Subject		: tg3 dead after resume
> > Submitter	: Parag Warudkar <parag.lkml@gmail.com>
> > Date		: 2009-01-29 0:14 (7 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123318968501524&w=4
> > Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> > 		  Rafael J. Wysocki <rjw@sisk.pl>
> > Patch		: http://marc.info/?l=linux-kernel&m=123365342301877&w=4
>
> OK to close - haven't checked if the patch made it to Linus' tree,
> assuming yes.

It's on its way.  Just applied it to my for-linus branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
