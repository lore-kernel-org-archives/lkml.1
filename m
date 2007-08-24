Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbXHXVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbXHXVNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXHXVNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:13:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:9994 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbXHXVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mAS8JsTFsVr7KTcMzm3QA+ey+frEkpyXOL+PK2/AeB2WpZjEZ0ezvesuXg4MJFGD5l6eiqevhqLwDh+4AbKssvLZmuJTCwozU8tUcU0TmMjng9BcbcBvcKArabamopdmqiAzQ6OJ2t4oDcjUobalt+B3AN3n7JmurjNAkBt44kc=
Message-ID: <625fc13d0708241413s1086527id377b49e7adacc5e@mail.gmail.com>
Date: Fri, 24 Aug 2007 16:13:21 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Casey Dahlin" <cjdahlin@ncsu.edu>
Subject: Re: USB Key light on/off state depending on mount
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CF468E.1080607@ncsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF468E.1080607@ncsu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Casey Dahlin <cjdahlin@ncsu.edu> wrote:
> Most USB keys nowadays have a small LED somewhere inside of them that
> lights up when they are plugged in. On a windows box, the key is lit up
> whenever it is mounted, and as soon as it is unmounted it turns off,
> giving a handy physical indicator that the key is safe to remove. On
> linux, the light is simply on whenever the key is plugged in.
>
> Should linux toggle the light depending on mount state? Is it as trivial
> as it seems or does this reflect some larger issue?

I think that depends on the key.  My Corsair keys have the light
flicker whenever I/O is on-going.

josh
