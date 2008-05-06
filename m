Return-Path: <linux-kernel-owner+w=401wt.eu-S1765291AbYEFQHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765291AbYEFQHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764606AbYEFQET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:04:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:11940 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764959AbYEFQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dJdwnrMgTIX0IQmn+CJo8sJhnZlAhlhS7veVi8iq3HCmWXW+yvd6FGA3jC2rQ88AEOn6OGVpC+qFhMcEoOfp0XyTq/5iwFPL4s9AjEQHgLDOyPhnkzjBxk3M/05aFA8umnqZS+AL+AQhERA2E8bY63QwilSh6D6w6mdxXfTQw00=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] m68k: Fix falconide `data_adr' typo
Date: Tue, 6 May 2008 17:57:35 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <Pine.LNX.4.64.0805052114380.15634@anakin>
In-Reply-To: <Pine.LNX.4.64.0805052114380.15634@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061757.35775.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
>     commit 9567b349f7e7dd7e2483db99ee8e4a6fe0caca38
>     Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>     Date:   Mon Apr 28 23:44:36 2008 +0200
> 
>     ide: merge ->atapi_*put_bytes and ->ata_*put_data methods
> 
> introduced a typo (`data_adr' instead of `data_addr'), leading to a compile
> failure.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks Geert.
