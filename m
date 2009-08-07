Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZHGL4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZHGL4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZHGL4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:56:15 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:62242 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbZHGL4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=l2DCk3iNMHnAaged/reDY18SkUttXsGcGPpc29Kn3qZA/Mf2i90Cmwj1Z5fx2RkUKY
         JIQD3rNbccSn+oEFAEdBUxuaP5p6qOd6R0C5o3M9iE/SWcduTDVE1upMNdz0TQmG5kah
         cqCfW8tknapffIpcw2mzCs+26Ht8YX2M9jHfA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the IRQ context
Date: Fri, 7 Aug 2009 13:55:21 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090624.025518.75726622.davem@davemloft.net> <200907011835.27586.bzolnier@gmail.com> <20090701.134729.13610576.davem@davemloft.net>
In-Reply-To: <20090701.134729.13610576.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908071355.21648.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009 22:47:29 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Wed, 1 Jul 2009 18:35:27 +0200
> 
> > On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:
> >> On Wednesday 24 June 2009 11:55:18 David Miller wrote:
> > 
> > [...]
> > 
> >> > I know you're busy, so I'll try to draft something up myself.
> >> 
> >> Ok, thanks.
> > 
> > Any news about these fixes?
> 
> Will get to it before the end of the weekend.
> 
> If I fail or abort, I'll integrate your version of the fix Bart, don't
> worry :)

Not that I'm worried but just out of curiosity..

Could you please tell me which week/month/year are we talking about here?
