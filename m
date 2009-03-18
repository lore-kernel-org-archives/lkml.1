Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZCRVCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZCRVCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZCRVCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:02:19 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:41523 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755898AbZCRVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:02:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u32xeR1AzUq7bWDX1uCJtIbW5TrxF33E8dFhup96QocN70G6uE9Er19AH5ozK0iekTLe0UwFqTnKStWRA/XmHcQggz3cNSGtlM9sFZm2AVRpSe+B3Mz4y1YSDMXBwOmNSjy1fiJ0Cd0KyDdnISOnKD8GO++dJYyJon+TTsdhTaM=  ;
X-YMail-OSG: QFFuRdQVM1nz7IsULfkzAJSujOcan0esJy5oAWerkeaFI2aUaT200jc_6bY1ZVSfPF6f5yjGLSzJXAN_VIrgqRwW2jJtc3IOMAYIlgVKdIxhA.u7BWu8DR.sCENi7MEgdEPuNHjDIUj2DRpurJEszyxsg_Xv5rAbQ4dUsqDzNRGfTRg64AoM7QTNY_x3XpkkmZs3hvYdf01UxnYz95BSJ__41EIOKg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Date: Wed, 18 Mar 2009 14:02:14 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903181225.11444.david-b@pacbell.net> <20090318203317.GA6299@sirena.org.uk>
In-Reply-To: <20090318203317.GA6299@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181402.14384.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Mark Brown wrote:
> > The $SUBJECT patch will prevent such things from existing.
> 
> I sent a patch backing that specific change out along with the
> late_initcall() patch.

Huh?  $SUBJECT patch hasn't merged.  How could you
have backed it out??

  http://marc.info/?l=linux-kernel&m=123707714131036&w=2

I didn't see such patches.  Could you post URLs so I
know specifically what you're referring to?

In the future, when you're proposing patches you think
address bugs I've reported, please remember to CC me ...

