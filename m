Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYJ1KLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYJ1KLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJ1KLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:11:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:10615 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYJ1KLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=V/LvlBQkKrc3z49fJLxkEDmXIaLs53YBxeLvbMt8ESKWT0md+jZK3J9Vy1XrvF/g/x
         QZd83B44BKjLaZhqOIoAO7ASDELv7KI85a9LyXE9gvhFnwWqWo4WKQ222NPzx1bMwObY
         +NK3LOEHaE+fGLKTDr6wl5bU8b+y/fxGCQMgs=
Date: Tue, 28 Oct 2008 10:10:59 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Remove unused variable warning
Message-ID: <20081028101059.GA3227@hack.voiplan.pt>
References: <20081028083512.GD19691@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081028083512.GD19691@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 04:35:12PM +0800, Jianjun Kong wrote:
>
>net: Remove unused variable warning
>'min_ds_timeout' and 'max_ds_timeout' are only used when CONFIG_AX25_DAMA_SLAVE is defined.
>
>net/ax25/sysctl_net_ax25.c:27: warning: ‘min_ds_timeout’ defined but not used
>net/ax25/sysctl_net_ax25.c:27: warning: ‘max_ds_timeout’ defined but not used
>
>
>Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
>---
> net/ax25/sysctl_net_ax25.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>


http://www.gossamer-threads.com/lists/linux/kernel/985658

-- 
"Sometimes the only way to stay sane is to go a little crazy."

