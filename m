Return-Path: <linux-kernel-owner+w=401wt.eu-S965404AbXJPUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbXJPUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935814AbXJPUPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:15:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:36193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935692AbXJPUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B/1vzsD5P+ASg15/FqaaxmiGWSd+ld7s+RQiP4TTU6Y5uM+BP1vZfmLsKtSvBOdnrkoJIxqhgm9DnoAytuPoKFKdmeORvAJwgz6qXMWbg34qb+ETFC+AX+q8T6LKxp5eoiausW3PzEHaJ+zxU+3WNkB680JGBHHie6t4EuhB8mw=
Message-ID: <d120d5000710161315p7d9081b2s63b13e5369964f56@mail.gmail.com>
Date: Tue, 16 Oct 2007 16:15:12 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20071016200207.GA23246@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015210737.GA15293@khazad-dum.debian.net>
	 <20071016141153.GA3237@khazad-dum.debian.net>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <20071016192010.GA26692@srcf.ucam.org>
	 <20071016200207.GA23246@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
>
> And unless Dmitry agrees with Linus' suggestion (maybe as a temporary
> stopgap while something better gets written?), we are not going anywhere,
> anyway.

"Nothing is more permanent than a temporary soution" (not sure who
said this). :)
If we do that we will have to live with it for many years.

-- 
Dmitry
