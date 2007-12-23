Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXLWXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXLWXIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXLWXH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:07:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:6767 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXLWXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=N9/qjWfYggpcgNcpBWKjJCS8Seh7jO1+Eau+UV+twa6GkCAGT/fMpurgVyqezgcNjgf32jbegt3o7SrBjD3A7XEtjkP+tLpV0F6nDuhq490VR/XFHuHkWag23c8JF+ue6TKQZEBeMxD3n/FUAl+KQafEPuuFoL5iI9IKqPL6lk0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH 00/63] ide-cd: redux
Date: Sun, 23 Dec 2007 22:39:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200712200148.49690.bzolnier@gmail.com> <200712212057.49502.bzolnier@gmail.com> <20071223065525.GA5003@gollum.tnic>
In-Reply-To: <20071223065525.GA5003@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232239.31798.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007, Borislav Petkov wrote:
> On Fri, Dec 21, 2007 at 08:57:49PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 20 December 2007, Borislav Petkov wrote:
> > > On Thu, Dec 20, 2007 at 01:48:49AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Hi Bart,
> > > Hi all,
> > > 
> > > > PS ide-cd Maintainer position is still open...
> > > i'd like to take that position if nobody objects. I've done some work around the
> > > kernel here and there and i think its time for me to get serious.
> > 
> > Great!
> > 
> > Please send me a patch for MAINTAINERS file updating ide-cd entry.
> 
> Sure, there it is:
> 
> ---
> 
> Reopen ide-cd for maintainership.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied, thanks
