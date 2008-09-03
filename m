Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYICSQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYICSQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYICSPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:15:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:19582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbYICSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=BSdWhkzkA0p4CHIt2OsyxAfTPJqytX/sQSz9km8NuviDajgWrOfHxNYUtyDNCGU3NH
         zaxtzhhlh5a38BRMAWmagMmFlLLjOhCIa7ohveC8CJ8mlOHgBS1qMglOY7BD7UdVI5GR
         c+appqtL64qVq/rXV37M2g0OpLIxjZDr7l5xU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
Date: Wed, 3 Sep 2008 19:43:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808192111.45351.bzolnier@gmail.com> <20080903094402G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080903094402G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031943.55605.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008, FUJITA Tomonori wrote:
> On Tue, 19 Aug 2008 21:11:44 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > Mark ide-scsi as deprecated and remove stale/bogus documentation.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/Kconfig |   16 +---------------
> >  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> Can we add ide-scsi to Documentation/feature-removal-schedule.txt?

Sure, care to send a patch?
