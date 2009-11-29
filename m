Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZK2QSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZK2QSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 11:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZK2QSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 11:18:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53767 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZK2QSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 11:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pMqbbcZLFNHlC1ElNUUWiE52yYvB14cPFgDDOgFqg9fvVkwqAk5wKV4IYOUIfHV38p
         TTV942xRFlqbEN9UMxpo54NuKQvdJnWF6mu0VG5Od2bG/Ia/MZOiY1mbmW3y74WNtrmB
         4ZaEvbK2+5XnAJ//j6DZj20rj2LAuhZqUz+EQ=
MIME-Version: 1.0
In-Reply-To: <1258373065.31356.16.camel@wall-e>
References: <1258372242.31356.1.camel@wall-e>
	 <1258373065.31356.16.camel@wall-e>
Date: Sun, 29 Nov 2009 14:18:27 -0200
Message-ID: <a4c8a6d00911290818o35cca889v6be5a08ce843f85e@mail.gmail.com>
Subject: Re: [PATCH 5/7] kfifo: add DEFINE_KFIFO and friends, add very tiny 
	functions
From: Thiago Farina <tfransosi@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 10:04 AM, Stefani Seibold <stefani@seibold.net> wrote:
> + * INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
nit: DECLARE_KFIFO
