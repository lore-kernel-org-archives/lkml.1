Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJ2KXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJ2KXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJ2KXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:23:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2846 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYJ2KX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=agGN2C+Zk7oX6r3h/l9PQu2VkQVUuoXqbtrYBm4LkTD3Xp3t4bjHRbVH1Jz2+ranoB
         54LQcoclvIvmNMB1yF7ctckRJnluKELNZuC3tcwBuJNztUhHCP39epGL9ndkQSVhzs8j
         6ScMOgeCZ/LXnVwIbrFl0VYAfCvRN6pLswyy4=
Message-ID: <84144f020810290323i63ce2584v60137ad5cdec5724@mail.gmail.com>
Date: Wed, 29 Oct 2008 12:23:28 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: w35und driver now in mainline/staging
Cc: "kernel list" <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081028201342.GA17362@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028201342.GA17362@elf.ucw.cz>
X-Google-Sender-Auth: c735d365bca4a032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:13 PM, Pavel Machek <pavel@suse.cz> wrote:
> Just... the w35und driver is now in mainline, and works (well enough
> to ssh over that; but I guess channel is hardcoded).
>
> Testers are needed; its easy, just grab latest 2.6.28-rc2, enable
> staging, enable w35und... and more testing would be helpful.

And should anyone with the affected hardware feel even more
adventurous, I'd love to have someone test my patches before I send
them out. If you're interested, please send me email. The prize for
testing the patches is, of course, a shiny "Tested-by" tag added to
each of them.

                       Pekka
