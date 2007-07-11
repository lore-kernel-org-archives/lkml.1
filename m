Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbXGKK5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbXGKK5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761383AbXGKK5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:57:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:6316 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761224AbXGKK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Db1XKMNWnpN505MiTVJF/BzxlCSUvdLRBXPyD3gxnWo8ml29DEgSjlekSGAWR0QZV3UVLrag3Rmv5xt1ongw6bn8tqWtiSbCDYYtOqU9w4qdiMC0TpsFB/ZKm4pJttBrdyMu2vSfEv2J+frQKQsjPCFOcZU+JkP8gs/QTdn0WQU=
Message-ID: <84144f020707110357w32a86672icef3374768537b5f@mail.gmail.com>
Date: Wed, 11 Jul 2007 13:57:22 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: revoke (Was: -mm merge plans for 2.6.23)
Cc: linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>,
       viro@zeniv.linux.org.uk, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
X-Google-Sender-Auth: 78fcfb00e4d0cc8b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 7/11/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Well, revoke is in limbo land waiting for the VFS maintainers to take
> a look at it...

Al took a peek at it and found holes. So no need to worry about merging yet :-)
