Return-Path: <linux-kernel-owner+w=401wt.eu-S935162AbZKYWDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbZKYWDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935148AbZKYWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:03:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44559 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935141AbZKYWDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=VlkaJefMlLXdW36RzqZll6cov8TYqoxeYAWwzHQPzg5ylAyXroMt0mdnRd2JhXc9Vm
         xH/qd1PixJVCrRuqwIufgn74kZPfNbbERElID/n2ROhnILl2pcHXr1P89a/K0+zsKQH6
         lnI+n+03LvM2W1HL04tTHumOueSGHUfhoSkZA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 62/86] pata_pdc202xx_old: document known issues
Date: Wed, 25 Nov 2009 23:02:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251929.45897.bzolnier@gmail.com> <4B0D95C3.4020706@garzik.org>
In-Reply-To: <4B0D95C3.4020706@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200911252302.18213.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 09:38:27 pm Jeff Garzik wrote:
> On 11/25/2009 01:29 PM, Bartlomiej Zolnierkiewicz wrote:
> > I think it is the best to leave up to the driver maintainer
> > (once we find out who this person is, MAINTAINERS file still
> > lacks info about PATA drivers in -rc8).
> 
> 
> The important thing is taking two minutes to write a relevant comment, 

If you want something changed in the code of pata_pdc202xx_old feel free to
make said changes.  I'm neither the author nor the maintainer of this driver.

It will only take two minutes of your time anyway.

> not determining who is wearing a crown on his head.

>From the fact that it takes years to make a tiny clarification for PATA
support maintainer I'm guessing that by "a crown" you've actually meant
"a crown of thorns"..

--
Bartlomiej Zolnierkiewicz
