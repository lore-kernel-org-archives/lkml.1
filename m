Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbXH0Vts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbXH0Vts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXH0VeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:34:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:11643 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbXH0VeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JprfnRwqL1/NjpV9MZroSu3asr9OO+/J887pnoqN8SrDIADh39yZ7Cc2X+nAxMxCxi5prcAF8H1w+1IN54xEG2aXxBHxVaGpdJHS64XTQeCjNVUl5eyjIylvB3ql41GQUI8Q1qILUF5tM7jali6cyVU43JrV1RYgR2AyKz9Zp1A=
Message-ID: <8bd0f97a0708271434y2d0dac76v6ab4036cec0aadd9@mail.gmail.com>
Date: Mon, 27 Aug 2007 17:34:21 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Olaf Hering" <olh@suse.de>
In-Reply-To: <20070827212743.GN4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch makes the 64bit integers on 32bit architectures usable for
> all C parsers that know about "long long".

ah, yet another attempt at this stuff

you probably need to update linux/types.h as well
-mike
