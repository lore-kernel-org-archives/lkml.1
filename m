Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbXDKLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbXDKLlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXDKLlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:41:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:57289 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbXDKLlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JQNv8C6leIS0EsVOTpOkxGRRhoQjb/vIdR3DJqygkkzuLsBDebw9BXq2FvssRfC1+JFEwV2TXmRpoJlNZbYUmAq/qRtvdMwYejaAhYOsF+qr8IdwlXG8ayWGhbB1sc4sgIGBHO67IthvcQejjFALfNQ16hwav8o1Ie5FIOkEGhs=
Message-ID: <b647ffbd0704110441x93845fdhb52541ff8ba5873a@mail.gmail.com>
Date: Wed, 11 Apr 2007 13:41:15 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "surya.prabhakar@wipro.com" <surya.prabhakar@wipro.com>
Subject: Re: rsdl:mouse freezing while doing git-gc
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1176279462.8833.8.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176279462.8833.8.camel@bluegenie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/07, surya.prabhakar@wipro.com <surya.prabhakar@wipro.com> wrote:
> Hi,
>    I am using the kernel 2.6.21-rc4-rsdl. Machine is a P4 2.2 ghz with
> 512mb ram. While doing a git-gc with nice 19 , I am still seeing that my
> mouse keeps freezing occasionally and other windows do not respond
> immediately.

Do you get { pretty same / worse / much worse } feeling of
interactivity with git-gc running at the default (0) and, say, 5 or 10
nice levels?

TIA,


-- 
Best regards,
Dmitry Adamushko
