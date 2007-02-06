Return-Path: <linux-kernel-owner+w=401wt.eu-S965386AbXBFB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386AbXBFB7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXBFB7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:59:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:62787 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386AbXBFB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XDh/iSQYRsQ1mZRP3yxfa+M8hQ3Dz4Cr/gUJMTn8ilVNWT7T9DnaZtreJnGqOmVlbitQirDCpjGngV9Loqf1v3Tm+arOCKJdge6ySH20/BBrZAUyEhhz9tx/ek4By1VoJJpk2a+D2Z5pPKGNbTmTnmb1o8kzLNXF+Cvmxt73e3c=
Message-ID: <8bd0f97a0702051759n1e5217fcv18a51aa8125d36f5@mail.gmail.com>
Date: Mon, 5 Feb 2007 20:59:20 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] Blackfin: architecture patch against Linux kernel 2.6.20
Cc: "Wu, Bryan" <Bryan.Wu@analog.com>, akpm@osdl.org, arnd@arndb.de,
       rdreier@cisco.com, castet.matthieu@free.fr,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070205173428.9f2109a4.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D3664A3D9376A94BB603EE19E4AA246D10D64758@nwd2exm4.ad.analog.com>
	 <20070205173428.9f2109a4.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> I can't access this patch file.  (no, don't attach it for the mailing
> list)

please try this:
http://blackfin.uclinux.org/gf/download/frsrelease/25/2501/blackfin-arch-linux-2.6.20.patch

as it gets tweaked, the magic id # gets incremented :/

this URL should contain the latest link:
http://blackfin.uclinux.org/gf/project/uclinux-dist/frs/?action=FrsReleaseView&release_id=25
-mike
