Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbZHGSfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbZHGSfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932358AbZHGSfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:35:45 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:35985 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbZHGSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jl5rnOtAp83+oJXzB0OwY0bZNXhHTbS8gN7cbz+615m1kQcQAKo9OT83oCwM/G0Dbf
         ZLDvgEfQR5EQgIYcJLQdcstRSxAbemUkj7rNKbIM+JY77ei75PRyz52g7rxvhx02D+DQ
         oiCv6VjyfcmYftV/lRgLmOSNxOnCAjo8ijVOw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Fri, 7 Aug 2009 20:35:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200908071927.36367.bzolnier@gmail.com> <200908071946.07991.bzolnier@gmail.com> <20090807.110952.124497199.davem@davemloft.net>
In-Reply-To: <20090807.110952.124497199.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908072035.07754.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 20:09:52 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Fri, 7 Aug 2009 19:46:07 +0200
> 
> > I've been looking and I've seen you pushing non-trivial IDE bug-fix
> > patches with almost no wider hardware coverage to upstream (i.e. one
> > of my own patches which has been _explicitly_ marked as needing more
> > linux-next exposure)..

Please note that the above incident caused unexpected/urgent work for
me so I would very much prefer to avoid such things in the future..

> "When are the patches to be applied?"
> 
> "You're a hyprocrite for applying these patches without hardware
>  regression testing you said is necessary."
> 
> Ok, you're position is clear :-)

Those are your own words (not mine), same goes for interpretation.. :-)

> Anyways, the ide-next-2.6 tree is up on kernel.org for all to
> enjoy and test, I look forward to everyone's feedback.

Thanks!
