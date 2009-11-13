Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZKMWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZKMWZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZKMWZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:25:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13826 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbZKMWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:25:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eALrhv9P3yDm+yKPB/ddkdX8DplOp+jR+h10MMKQVqjeiRvuYBrtAqbJqXeoBoRLJZ
         5TfW4VXYypIKLMyUv4pTrXSmkgHnJN/ooH/DGmVc0IGqW2IN0zOUh9ndaM4xQzE2mHuB
         1YqxwZXbqBebllE4iEn/pIgmHIYH3c7LsrBOA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Fri, 13 Nov 2009 23:24:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
References: <4AFCC0D4.9020708@gmail.com> <200911132039.06929.bzolnier@gmail.com> <4AFDD65F.5090605@pobox.com>
In-Reply-To: <4AFDD65F.5090605@pobox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911132324.18537.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 22:57:51 Jeff Garzik wrote:
> On 11/13/2009 02:39 PM, Bartlomiej Zolnierkiewicz wrote:
> >> Any others spring to mind while you are at it ?
> >
> > HPA handling related patches that were "being worked on" if you really
> > would like to know..
> 
> 
> Can you elaborate on this one?

Certain someone announced that he was working on porting my IDE HPA work to
libata, after almost half a year there is nothing out of it and all my queries
regarding the status of said work are ignored..

I begin to assume that such announcement was just a well planned strategy to
put stop to my (then ongoing) attempts in reaching other libata developers in
helping me with porting the code..

-- 
Bartlomiej Zolnierkiewicz
