Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbXEJMwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbXEJMwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXEJMw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:52:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbXEJMw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LShmHTJEuPjCY6AHLzc93/eiBnRdviF33gXyodW+V7Aa8Z1WudzJEq1sjhYHf4ayA790c6IZYvkP86NjtDDdmLXfY3HkHtFwf6pO3zqbifazh9kDF/zy9i5aAGM9mJII8cZHQAWRfnblIyp+Vjxe87iftwDvI56vAhcCrq/Z/Uc=
Message-ID: <84144f020705100552u3f988e80u29fc412737522259@mail.gmail.com>
Date: Thu, 10 May 2007 15:52:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070510134816.5e57e3cb@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510015555.973107048@polymtl.ca>
	 <20070510020917.172554217@polymtl.ca>
	 <20070510065847.GE8019@infradead.org>
	 <20070510124120.6e8ac5aa@the-village.bc.nu>
	 <20070510114158.GA16741@infradead.org>
	 <20070510134816.5e57e3cb@the-village.bc.nu>
X-Google-Sender-Auth: a0abeaf5e6f5057c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> "blobs of crap" - in whose opinion. Yours. So you don't want the kernel
> to mention things you personally don't approve of. Thats straight forward
> censorship and has no place in free software.

Out of kernel code comes and goes, so why mention it in-tree? Besides,
what's wrong with the suggested "can be used for tracing or
performance accounting?"
