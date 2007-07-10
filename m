Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbXGJWFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbXGJWFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761324AbXGJWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:04:51 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:21109 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761131AbXGJWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hnUGxNi5TY/t5DcRGJmpBgWFkKqLfDxxtN650aQ0Mu6KlZsp/mUjtkO1v1giCKMdPocQjovCk/VjN4bgKidhvkQB4EhDecAcQXF6+RSpIkfPxL+rKpJG3R0EAQms88CT6KfKSbQmblgVbLOZB4zs9G7qN3TlMNiFGgiD0cpmugk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marcin Juszkiewicz <openembedded@hrw.one.pl>
Subject: Re: [PATCH] PCMCIA: Add another MemoryCard to ide-cd/pata_pcmcia
Date: Wed, 11 Jul 2007 00:16:43 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200707101137.25955.openembedded@hrw.one.pl>
In-Reply-To: <200707101137.25955.openembedded@hrw.one.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707110016.43152.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ please always cc: linux-ide@ on ATA patches ]

^
s/ide-cd/ide-cs/ ;-)

On Tuesday 10 July 2007, Marcin Juszkiewicz wrote:
> From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
> 
> One card submitted by user.
> 
> Signed-off-by: Marcin Juszkiewicz <openembedded@hrw.one.pl>

This patch doesn't apply because of whitespace damage
(all spaces were converted to tabs).

I fixed it manually and applied.

Thanks,
Bart
