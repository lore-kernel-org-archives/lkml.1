Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYHMTe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYHMTe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYHMTeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:34:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:7109 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYHMTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Qz9wv7udoUAqwFSqnJweu6fy7voNa24+bOLIfqx37KRrUYkCdwQb2Ice++LKJynaP6
         GRsDBL2t2lQXnZWxKSq1rXptTx5cW+Hu5Eu+47/9O7/56NtOXS1+5gIPuJMKV7saHbud
         3/XeA9KlVu7nwu9/AOBH9NOPPJfiPCzem9I04=
Message-ID: <84144f020808131234r2787b214hde3a723541c4c19b@mail.gmail.com>
Date: Wed, 13 Aug 2008 22:34:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] slabinfo: fix printk formats
Cc: lkml <linux-kernel@vger.kernel.org>, sfr <sfr@canb.auug.org.au>,
       cl@linux-foundation.org, akpm <akpm@linux-foundation.org>
In-Reply-To: <20080813105234.86bbc894.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080813105234.86bbc894.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 1fe4a8270fbc5b0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Aug 13, 2008 at 8:52 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix slabinfo printk format warnings:

s/printk/printf/ :-)

Applied, thanks!
