Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXKNDDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXKNDDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbXKNDDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:03:37 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:59072 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbXKNDDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:03:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZdG4NabXCPz8lMSBxYWvRX368L2EGUAQofgnZc8z0zjxUdGFZ9G/mhCd6pLyBXL6zc7JJ9CFEoLnAOxdXEh9kEgLjx5z2s+5LQv0Atib9EzdDm+fXLyzi3cIA2NIhNQQDjdo8T99o6FVc3Knyqi1wg8qRmoslOHQItX7DukR9R4=
Date: Wed, 14 Nov 2007 11:01:27 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, trivial@kernel.org
Subject: Re: [PATCH] Let 'make help' output info about includecheck
Message-ID: <20071114030127.GA2506@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200711120056.35359.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711120056.35359.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 12:56:35AM +0100, Jesper Juhl wrote:
>From: Jesper Juhl <jesper.juhl@gmail.com>
>
>'make includecheck' is useful and we want people to run it, so 
>let 'make help' output information about its existence.
>
>
>Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

I think Randy Dunlap has done this[1]. ;)

[1] http://lkml.org/lkml/2007/11/4/120

Regards.


 Cong

