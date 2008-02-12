Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYBLV0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYBLV0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYBLVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:25:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYBLVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cD06Y6Z3FhWEmVw2GMGwh2izOrwrqwZa+qJTtbaOF0uPKyAtxYxVnQRjRaWlyvzmqhKlZSuIJddU//7eb3Qb6kS2LClTeWqhsen+mztczIfuBi9zgPbs+kNA5vNkv6r7BuECDewdA7a8rQ0QIiHnIkCgzoQ5Irw0a469w4S3rnY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy: rename end_request handler properly
Date: Tue, 12 Feb 2008 21:10:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080212143635.GA4530@gollum.tnic>
In-Reply-To: <20080212143635.GA4530@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122110.45593.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Borislav Petkov wrote:
> commit 48f9b88d491aa478ffcf21e2f523e3665db0770b
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Tue Feb 12 09:42:19 2008 +0100
> 
>     ide-floppy: rename end_request handler properly
>     
>     mv idefloppy_do_end_request -> idefloppy_end_request as is the case with ide-cd
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
