Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZBHKKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZBHKKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZBHKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:10:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:60382 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZBHKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PVr4/c41KjlMPJXXbKTBFI18CECjGRNeREpSOxGW8YfV0ksRLiWCssGirFa/LU4adK
         10gk1ArZSpdX9nIzqwsGuXn3UCbptu6vfMQGU59agQ3D/0UaLIOY7aUHcokT2HjUM+5R
         AD6GLi/xGC/iKThS6UVNLaWj0iYh+qt+SMal4=
MIME-Version: 1.0
In-Reply-To: <20090207164057.777f482f@infradead.org>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
	 <20090207200652.GA3255@x200.localdomain>
	 <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
	 <20090207205606.GA3490@x200.localdomain>
	 <20090207164057.777f482f@infradead.org>
Date: Sun, 8 Feb 2009 11:09:57 +0100
Message-ID: <c43b2e150902080209s2444718fjb08086eed1a835cc@mail.gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
From: wixor <wixorpeek@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, passing vmalloc=300M removed the BUG, still the screen is
looking the very same way it was before - rubbished. I guess I should
play with the module options now?

--
wixor
