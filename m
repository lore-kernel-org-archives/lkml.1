Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXCHVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXCHVbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXCHVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:31:17 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:26701 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbXCHVbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SB78FhcmagIUNO8ah4/5/djnML5KjsYLgd6bFsa5SYCtQnjewB0RTDF1P3YDK7ietKPF4ZlNkuyc1iMikE9JAK7dfyQcuS+ME3LRSdnx77xpFa72gfaAbnEzE9z/LTHm8WHbuhcUTbrKELhDePm9/3iEkLcONpMUGV9j1B7uLZ4=
Message-ID: <b637ec0b0703081331v4292c977j31cee7457c306880@mail.gmail.com>
Date: Thu, 8 Mar 2007 22:31:13 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
In-Reply-To: <200703090757.14917.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703041800.53360.kernel@kolivas.org>
	 <b637ec0b0703081225n49d9aa56h3e21c0f9c9bc7039@mail.gmail.com>
	 <200703090757.14917.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, downloaded - compiled - booted: initng measures 17.369 seconds
to complete the boot process; without the patch the same kernel booted
in 21.553 seconds.

Very impressive.
Many thanks for your work.

Fabio






On 3/8/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Friday 09 March 2007 07:25, Fabio Comolli wrote:
> > Hi Con
> > It would be nice if you could rebase this patch to latest git or at
> > least to 2.6.21-rc3.
> > Regards,
>
> Check in http://ck.kolivas.org/patches/staircase-deadline/
> There's an -rc3 patch there.
>
> --
> -ck
>
