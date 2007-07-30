Return-Path: <linux-kernel-owner+w=401wt.eu-S938907AbXG3Gdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938907AbXG3Gdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938246AbXG3Gdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:33:31 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:15213 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937953AbXG3Gdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IcSc7ElXYM1bqZPdMJOivfE2atKjVsHwcUcyWviiVZYVJ9caG5Mgoi+mgjK9vnVeJc5dpZ2XMT8TUiRLo6pyH4DaBE8YVuD6S/07MzItpibbtOut53jh2YobvV+Pikrf+iJqcxJtO5N1nw+fcoB9OXb8SOs1rxOapxcVEolzhCQ=
Message-ID: <8bd0f97a0707292333p7428f1f7l1a4bd41993592826@mail.gmail.com>
Date: Mon, 30 Jul 2007 02:33:29 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Blackfin: Remove duplicate inclusion of linux/irq.h
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Aidan Williams" <aidan@nicta.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
In-Reply-To: <200707292348.25880.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707292348.25880.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> arch/blackfin/mach-bf548/boards/ezkit.c includes linux/irq.h twice.
> This patch removes the duplicate.

thanks, but we've fixed this in our tree already, we just havent
pushed it to linux mainline
-mike
