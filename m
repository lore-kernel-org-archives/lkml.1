Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYLBTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYLBTgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYLBTgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:36:41 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:64902 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYLBTgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=d+nkvmuaGXEcYsx5pTVl8fW8Z2AxNLZq2LvkHP9Z4jrUXiDMwyau9U0kmESlziy3Tq
         sDvv8PZtzClly5/vDFwUlTywoiSzal8Fajkl7eM1hxFU2hwmk4Z1Fd05cLr3TCn0NP+1
         4rd36sf9vNMzYBxHeMb3f5HKUDoDppt63eRT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] alim15x3: fix sparse warning
Date: Tue, 2 Dec 2008 20:29:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128-dirty; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org
References: <493049e1.0ab6660a.0bc3.ffffaf3b@mx.google.com>
In-Reply-To: <493049e1.0ab6660a.0bc3.ffffaf3b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812022029.35785.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Hannes Eder wrote:
> Fix this sparse warning:
> 
>   drivers/ide/alim15x3.c:594:2: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

applied
