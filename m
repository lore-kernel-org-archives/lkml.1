Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbXJZTrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbXJZTrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXJZTra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:47:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49706 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbXJZTr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fuGOBKhNyazQo5mDaUGuknfo2pBFaiYmoRj0TjGMm9MuNswOULRJhJyWVAFBk82wWQVYkl6BLxOYSJnhwBk6hrysvYxQqpcrk3P3Pml0vEt1COTWs91ocHrGg9hULkS+yO2ISUHfI4KPPOgOodpaQASZfn9xp8D6aG9u92X2ggU=
Message-ID: <5d6222a80710261247x36fcd2a5qb3c1d8cc46d5e093@mail.gmail.com>
Date: Fri, 26 Oct 2007 17:47:27 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
Cc: "Adrian Bunk" <bunk@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4720E1F9.4020700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11933164723812-git-send-email-gcosta@redhat.com>
	 <20071025173605.GM30533@stusta.de> <4720D8EA.1090501@zytor.com>
	 <20071025183055.GN30533@stusta.de> <4720E1F9.4020700@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Adrian Bunk wrote:
> > Sorry for the dumb question, but how does or did the gcc -traditional
> > option affect ld?
> >
>
After a while, there is no issue I can find on x86_64 by taking out
the -traditional flag. Everything seems fine.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
