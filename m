Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYCFGxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYCFGxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYCFGxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:53:23 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:43415 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYCFGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:53:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qeXzX9IRReEhNVtAOTD179G460tgb3PiUuZWb9XqqmyEnbMrto+m4QzQ2mDTs8so6ZBgv+bY4qUPsMyMPNlcDeaZU4YORxQu/OXLQACojn+qKsZBrIRmNoP3cW/gk+vu2LZ7Ullqiki1h1DG4gWieDM4Iq1X7AescaLgU3j8RWk=
Message-ID: <e9c3a7c20803052253i61f55ee4k702c9ed961129cf4@mail.gmail.com>
Date: Wed, 5 Mar 2008 23:53:17 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 05/16] iop-adma.c: replace remaining __FUNCTION__ occurrences
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204770293.14154.41.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204770293.14154.41.camel@brick>
X-Google-Sender-Auth: e32b63f8a41569ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 7:24 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> __FUNCTION__ is gcc-specific, use __func__
>
>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>  ---
>   drivers/dma/iop-adma.c |   32 ++++++++++++++++----------------
>   1 files changed, 16 insertions(+), 16 deletions(-)
>

Thanks Harvey,

Applied.

--
Dan
