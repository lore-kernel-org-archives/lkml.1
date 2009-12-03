Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZLCTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZLCTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZLCTVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:21:17 -0500
Received: from mail-ew0-f210.google.com ([209.85.219.210]:47324 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbZLCTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Kn0fYQdmBQtzj6JQ7fYNph61DhMcxpFb+CuzLPH+0XBvFOs90dMlae6F/0qvvL8kNn
         48ajU6VLrEIY32bZzBHcrSrzQ3MN2H4mWdnT5jTHreRh4egRTgRzHQyxypXBhYAqhuQ8
         rKKNQXdpep0xlhGJvqlQ+jsEQ/sxvpIklwnZg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: What's in libata-dev.git?
Date: Thu, 3 Dec 2009 20:20:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <20091203075653.GA30612@havoc.gtf.org> <200912031647.26342.bzolnier@gmail.com> <4B180E04.5030405@garzik.org>
In-Reply-To: <4B180E04.5030405@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032020.16608.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 08:14:12 pm Jeff Garzik wrote:
> On 12/03/2009 10:47 AM, Bartlomiej Zolnierkiewicz wrote:
> > ( Jeff, you probably would want to take ide-pci-generic fix to your tree
> >    as libata-dev tree currently breaks build for IDE tree. )
> 
> I didn't know that.

You would know if you would be either:

	a) reading

or

	b) building

patches that you're applying.

> URL or search string?

I think that there were enough hints in my mail already.

Please use your own time to fix your own tree.

--
Bartlomiej Zolnierkiewicz
