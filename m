Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZBLGB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZBLGB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZBLGBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:01:16 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:42059 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750764AbZBLGBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:01:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TNjzvrBlKciC2qPDKgF5j04oYPqu++VW5c31Pgpb71Hy2J6V9P+Af8WNpFDcC8TcdwBxXyLRNeTGhiDyzp3xnrDCBASE7AO2nAfrXxLjR2dH45u+BwB7dhU/x24NnBL31DokokStlCKeEu4DG+t+5PtPck64GOdn60PMN1TOdEw=  ;
X-YMail-OSG: gqizJskVM1m7oIOQdbeQrlngaXJ6BqQ_OpLNMl8V.UcB.UjFW.kMwQB9UZFi.0uL7cZR2mF.SoZXKy4.3SJkiKv5t_4SJNS1ZffCxHUIi_yhZ8mfWiIBigxwpThgtD1YZ_hm2OLWNnf7jE6YW2LEDYlTKcmX.7R5Lu8hlkZzUzownReGSnLLaOgzeo8X
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused  warnings
Date: Wed, 11 Feb 2009 22:01:12 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org> <20090206191558.GD10711@frodo> <8bd0f97a0902061124s3c44d39dmf306a44f0c16528d@mail.gmail.com>
In-Reply-To: <8bd0f97a0902061124s3c44d39dmf306a44f0c16528d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902112201.12902.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Mike Frysinger wrote:
> > Is this patch avoiding a warning about these variables being unused ?
> >
> > Would be nice to get this info to the patch body ;-)
> 
> the subject already says that

Not enough.

Mike, why is it that patches from ADI generally don't include
patch descriptions?   It's not like folk haven't asked for them...

In the case of "avoid a warning" patches, the convention is to
have the patch summary include the warnings being avoided.
(Or at least a few, if they're too numerous.)



