Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYCaQhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYCaQhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYCaQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:37:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:35492 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYCaQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qJCil7Z+K53HeKhvUynRpbd1Gbio5an4EvTcb1u3lLlfr9neSg/Xvjs+RhFpB/xMaMjvWHFIcXc4klRzLHSiEk7q6mtoqslO9aFSbQcl0PV2NnxDRlo316QSyLEiLnDpQhbLME6Qj6d5WnNnPnCRm96pWrTdwBHmO3sEXaj7Tmw=
Message-ID: <e9c3a7c20803310937l52fdc82ejc493abbac347d427@mail.gmail.com>
Date: Mon, 31 Mar 2008 09:37:39 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: [PATCH] [POWERPC] fsldma: Use compatiable binding as spec
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       wei.zhang@freescale.com
In-Reply-To: <Pine.LNX.4.64.0803311115540.5470@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0803311115540.5470@blarg.am.freescale.net>
X-Google-Sender-Auth: b8b40cb69b4efe90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 9:17 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> Documentation/powerpc/booting-without-of.txt specifies the
>  compatiables we should bind to for this driver (elo, eloplus).
>  Use these instead of the extremely specific 'mpc8540' and 'mpc8349'
>  compatiables.
>
>  Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>  ---
>
>  Dan, if you don't have any issue with this I'll sent it via the powerpc
>  tree (since its not really about functionality).
>

Acked-by: Dan Williams <dan.j.williams@intel.com>
