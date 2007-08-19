Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXHSRj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXHSRj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 13:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbXHSRjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 13:39:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:56288 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXHSRjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 13:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D0dAaGy1D3x8r37LLvONyQduA8fK7s/V2X0poVPybq64krQaKMp4+zqC8tSkFxFlJdW7kC8spvmOSUSJo1TZEZwKBMZLKp9tPjRJHmAya4OMBvwhBwrOopYqgRuRGdn5BRxTBP2M1wwFRG1kZdfCfy0H6PMjMPTF+CXVJtdCbXo=
Message-ID: <9a8748490708191039v47eabf7jd1807fc8c1d5ec05@mail.gmail.com>
Date: Sun, 19 Aug 2007 19:39:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: phreak@gentoo.org
Subject: Re: [PATCH] Remove double inclusion of linux/capability.h
Cc: linux-kernel@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Andrew Morton" <akpm@osdl.org>, "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <200708191308.00043.phreak@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708191308.00043.phreak@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/07, Christian Heim <phreak@gentoo.org> wrote:
>
> Remove the second inclusion of linux/capability.h, which has been introduced with
> "[PATCH] move capable() to capability.h" (or commit c59ede7b78db329949d9cdcd7064e22d357560ef)
>
This is already fixed by one of my patches currently sitting in -mm.
-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
