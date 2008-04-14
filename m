Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYDNXKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYDNXKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763197AbYDNXJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:09:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:10967 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763158AbYDNXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lGfd7wh6IfcKYq5A/3sbBeKH/kFXYr2pz456vSuCvsMrAsmgnN084Ptt1Q71I0F1kBrO3SyoSqDASm3BgCMqgl1whfuk9HR9dl5QHmPy62BjpMKf3bbmmbGboQTU92lvmmqRrrnK8ATLDMXyeO1uNJajeaH+ndQ8Of4ofx64sPc=
Message-ID: <ed10ee420804141609y755913fct1d046cf8f644b99c@mail.gmail.com>
Date: Mon, 14 Apr 2008 16:09:41 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: "Jeff Garzik" <jeff@garzik.org>, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, miklos@szeredi.hu,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080414141139.10d4d4c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <1208121358.2700.4.camel@shinybook.infradead.org>
	 <20080413154459.4b2f125d.akpm@linux-foundation.org>
	 <20080413234920.63711ca7@core>
	 <20080413161014.cb06964c.akpm@linux-foundation.org>
	 <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
	 <4803C4A8.7020304@garzik.org>
	 <20080414141139.10d4d4c0.akpm@linux-foundation.org>
X-Google-Sender-Auth: 208e47536898e57f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/08, Andrew Morton <akpm@linux-foundation.org> wrote:

>  Guys, a few years ago Linus's rule of thumb for merging an FS was,
>  approximately, "it is already being shipped by distros".  The bar is _much_
>  lower than that now.  Largely because I personally think that it should be.

I thought he wrote in the lead message that it had been picked up
by at least three different distros.  Does that not count?

-sb
