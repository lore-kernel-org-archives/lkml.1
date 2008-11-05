Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYKEVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYKEVvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYKEVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:51:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:35272 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYKEVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:51:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Wx7ff8180HHBiyX1WzHKTwumWAHuYaH34bPhBRFirYXhAh4yTzZJi5lT/dHZdd4oz4
         5fJTaQeVkmFLHt7fuG0LGctAn/m+xwasnTqQz4w0BbcS+lJRh+W385RZGB/NboHEqphJ
         CACyxS06gLkT3SrFvlRoid25Rdz/qwSnXqVRQ=
Message-ID: <9e4733910811051351t721abbe3p5630b1ab55d134da@mail.gmail.com>
Date: Wed, 5 Nov 2008 16:51:21 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [RFC PATCH V4 3/6] Configfs support for IR
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081105214117.GB3966@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105194640.19407.19682.stgit@localhost>
	 <20081105194742.19407.35855.stgit@localhost>
	 <20081105214117.GB3966@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 4:41 PM, Pavel Machek <pavel@suse.cz> wrote:
>> + *   ------more keymaps
>> + *   --------....
>> + *
>> + * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
>
> GPL?

Yes, will fix in next version.

>
> Maybe those -s should be /s?
>
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
