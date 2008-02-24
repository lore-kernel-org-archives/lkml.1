Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYBXR10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYBXR10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYBXR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:27:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:33221 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYBXR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ct6WNGs4SNIav39jQyY67OYbNzMbnri5R1u7cJSz2rfAjihtKkkMSjyL4dL/FyPk5be9aamhMrNRPRQhkOzJzbQuVpMaOmoOI7CQeFEuqJXM2b9/fYUAiQWbmhn+wrYriyfKu8hfwq1Ovw47SZUz2bGISA11iOeFyoVHBDo4Q20=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] libata fixes
Date: Sun, 24 Feb 2008 18:40:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080224053508.GA17530@havoc.gtf.org> <200802241821.15052.bzolnier@gmail.com> <20080224170735.7fed8ab6@core>
In-Reply-To: <20080224170735.7fed8ab6@core>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241840.25452.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008, Alan Cox wrote:
> > From the patch description it can't be told whether the patch itself is
> > correct and only the patch description is bogus...
> 
> zero length PRD misparsing. If I remember rightly old IDE never generates
> 64K PRD slots because other hardware can't handle it either (CS5520/30
> etc)

OK, that would explain it.

Thanks,
Bart
