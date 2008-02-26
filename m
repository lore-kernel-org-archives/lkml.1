Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbYBZXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbYBZXRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763326AbYBZXRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:17:00 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:36164 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762356AbYBZXQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zc6BbWGDKqipH2o/guqlT1DUHz+zjdiRIkzcYrblgbxbBMTqnfCsUMgV/WW96rmWWyam3IvukzFtB7+GycfZFLNHZBCQbdvY/jTB9muWXX9hpa6EhgIUIP6k1Ju1AcR+V3JeGy9i7QZ54uA22WY9brwuG5zlGtXimGuvSgI9PNw=
Message-ID: <4d8e3fd30802261516g5f4ca763kd4f8405f136b9847@mail.gmail.com>
Date: Tue, 26 Feb 2008 23:46:53 +0030
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cd: fix some codestyle and most of the checkpatch.pl issues
Cc: "Borislav Petkov" <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Borislav Petkov" <petkovbb@gmail.com>
In-Reply-To: <200802262337.29873.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204012194-4208-1-git-send-email-petkovbb@gmail.com>
	 <1204012194-4208-3-git-send-email-petkovbb@gmail.com>
	 <200802262337.29873.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
> On Tuesday 26 February 2008, Borislav Petkov wrote:
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> > drivers/ide/ide-cd.c | 634
> +++++++++++++++++++++++++------------------------
> > 1 files changed, 323 insertions(+), 311 deletions(-)
>
> With 300 lines changed this is not trivial to review/apply anymore
> (yeah, I sound like a broken record ;-) and since I've already applied
> Paolo's patch from two days ago this one heavily rejects...
>
> Moreover md5sum is different before/after the patch - I tried really hard
> to figure out why (by reverting some changes) but finally I gave up.

is it because of the changes in the include section?
and was the change suggested by checkpatch.pl?

ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
