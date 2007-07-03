Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbXGCReG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbXGCReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbXGCRdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:33:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:18268 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXGCRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TRAEEkYLjGX1G4LHlr1hESZlRul5O9CDXlLFcunVIjJNIme+UCLM3lAmfCvzgLYaO5n/xJszmjc9g44SKohrj010ReEWoLcRQ4lOnQQN68aRajqXNpWs3CG1hsNLc5zr/zbrJEUK0s4BVvZiC+oFIup/eoI/5nKmetZo0ASfAPQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
Date: Tue, 3 Jul 2007 19:50:26 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
References: <468A7D14.1050505@googlemail.com>
In-Reply-To: <468A7D14.1050505@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031950.27162.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 03 July 2007, Michal Piotrowski wrote:

> IDE
> 
> Subject    : 2.6.22-rcX: hda: lost interrupt
> References : http://lkml.org/lkml/2007/6/29/121
> Submitter  : David Chinner <dgc@sgi.com>
> Status     : unknown

David, any news on this one?

Have you tried libata as suggested by Jeff?

[ would exclude IRQ routing issue or broken hardware ]

Thanks,
Bart
