Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXBGBGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXBGBGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965630AbXBGBGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:06:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:33149 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965626AbXBGBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4bGHuw3advNn46qLa2Znbv9UgJrxEpecjgmN56BuPxoIDdTYE9eIsIHr/COZKzDMY55oNzpopbOeMPNcUyrQv0t0TApq12AN9n6Y08SsPjpEVRCaVW4dO61nrKszsjRPawNK6SjJSNOEdRyukC4dwq138wmg/TCM/ahqPe7hE8=
Message-ID: <58cb370e0702061706o162c4235w10e5e95782a9bee@mail.gmail.com>
Date: Wed, 7 Feb 2007 02:06:06 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ide section fixes
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <58cb370e0702061448o300c5378p19fb7999d11e109c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HCcMg-0007QC-Vk@ZenIV.linux.org.uk>
	 <58cb370e0702061448o300c5378p19fb7999d11e109c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On 2/1/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> > a) cleanup_module() should be __exit
> > b) externs should match reality
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
> applied, thanks

hmm, Linus has already applied, great :)
