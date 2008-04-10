Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYDJVtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYDJVtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbYDJVtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:49:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:64954 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbYDJVtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QAhKWWwwY5aUufIRYWC05siH9ByKm4SEfDOVnocITi/Ls3VaXSh/6I+beW6K7xocwVdW6KV9Z9RzomX4eoBIjWqFe58bZgDFcmZpK6g/ppRLtVfb3VhbmXOn6GwAyPupIwdwIqr/gDSX4z4L7Otmffn+jKJHtjKY1TYaOps2S1w=
Message-ID: <86802c440804101448n7fe5d04x315a30ba877774f4@mail.gmail.com>
Date: Thu, 10 Apr 2008 14:48:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor -- payload_length
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
In-Reply-To: <47FE8AB1.90506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
	 <47FE7A6C.1070405@zytor.com>
	 <86802c440804101415o55af93c8o8f4dc54dfad8662e@mail.gmail.com>
	 <47FE8AB1.90506@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 2:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > arch/x86/boot/compressed/head_64.S?
> >
> >
>
>  Sorry, I don't understand.

where can i find the unzip paload size from payload hdrs?

YH
