Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZKUSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZKUSxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZKUSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:53:18 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45252 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZKUSxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rt8oDQ+Z2wy1teSFRtHpOuBHrB3bIbjPITRUlkCxcFdxv00H4BWP3lHYTnlLNXGBNk
         e4X2/6HYor/j8jq+Ce0kIxamfynFd4O68lKLr+Xo51l204togqpCFJizHsOU7I8TRBIN
         J2Olo3OKdOtG5SENiju0+jnKrQfAAERYiCn6Y=
MIME-Version: 1.0
In-Reply-To: <4B083957.3040500@gmail.com>
References: <4B0838F1.4090202@gmail.com> <4B083957.3040500@gmail.com>
Date: Sat, 21 Nov 2009 16:53:23 -0200
Message-ID: <a4c8a6d00911211053j628a7d60ve0a3be599d9a0632@mail.gmail.com>
Subject: Re: [PATCH] viafb: Use sizeof struct rather than pointer
From: Thiago Farina <tfransosi@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Joseph Chan <JosephChan@via.com.tw>, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 5:02 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The returned error should be negative
>
Hum? This belong to this patch?
