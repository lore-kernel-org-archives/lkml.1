Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZK2QRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZK2QRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 11:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZK2QRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 11:17:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65046 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZK2QRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 11:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x4OeB/pjtYBErgNehiXi+/MR4gSW2MEGgQuWH+rR5AOJbOTRiZKjJPQgLShCqjdOwa
         REm46/jh7Pf4xeg6PY1rAmkC8Rr8HxJ2ExzIJrSfxzZqbwwMe0ilrjQI4TNKSmuLhK/R
         RKqSc5AkOCWpUI09lozmDc/0OByGztbctUXV0=
MIME-Version: 1.0
In-Reply-To: <1258704942.4426.5.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
Date: Sun, 29 Nov 2009 14:17:41 -0200
Message-ID: <a4c8a6d00911290817l615cb088x72a38cb09897bb6@mail.gmail.com>
Subject: Re: [PATCH 0/7] kfifo: new API v0.7
From: Thiago Farina <tfransosi@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 6:15 AM, Stefani Seibold <stefani@seibold.net> wrote:
> The API:
>
> Macros defined for kernel FIFO:
> -------------------------------
>
> INIT_KFIFO(name)
>  Macro to initialize a with DECLARE_KFIFO declared kfifo
Maybe: "Macro to initialize a kfifo declared by DECLARE_KFIFO"?
