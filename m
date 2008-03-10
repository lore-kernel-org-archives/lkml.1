Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYCJTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYCJTJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYCJTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:09:29 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49846 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYCJTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FV21DDFkT3+pE3RLPmbEWVERTM/rX/lqf49uwr38pJE7rdZ+Q1QNPIgijyT9vN+YjByULSlaISBbVi36Ajy7Su3ngBBQ4MpbEXJNBLgaScDGuuVoY26n5wf5V+H8Vqf/2vmE50dpW8LeKBhhtxAEZnU9QjYEB4K5vyA1tTIm79I=
Message-ID: <e9c3a7c20803101209k7cd9063ek9dd7e732d836e795@mail.gmail.com>
Date: Mon, 10 Mar 2008 12:09:25 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>
Subject: Re: [PATCH] Fix fsldma.c warning messages when it's compiled under PPC64.
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
In-Reply-To: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com>
X-Google-Sender-Auth: 0c2e0e25561725bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 3:47 AM, Zhang Wei <wei.zhang@freescale.com> wrote:
> There are warning messages reported by Stephen Rothwell with
>  ARCH=powerpc allmodconfig build:
[..]
>  This patch fixed the above warning messages.
>
>  Signed-off-by: Zhang Wei <wei.zhang@freescale.com>

Thanks, this is applied and pushed back out on async_tx.git#next.

--
Dan
