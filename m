Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbYEUHUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbYEUHUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYEUHUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:20:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:24928 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406AbYEUHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iYQR3nItK4ZfSppjPx/RtqPEC1qM2jk/2JZa3BppCgrG6Cjl4FdYQCwToJI+0au9d9LoTAeDMxMNlQnjN0rgH5DZPbwZwFELVuwq3lTgGEavlAoUpU25N9iir7rHb4Wnj0HKN8AE35az5Q93US8M8dO4r4b7LSvC8+nnbz2bWyk=
Message-ID: <4833CD18.9030402@gmail.com>
Date: Wed, 21 May 2008 09:19:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jianjun Kong <kongjianjun@gmail.com>
CC: torvalds@linux-foundation.org, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Standard indentation of arguments
References: 0002-Standard-indentation-of-arguments.patch <12113495282137-git-send-email-kongjianjun@gmail.com>
In-Reply-To: <12113495282137-git-send-email-kongjianjun@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2008 07:58 AM, Jianjun Kong wrote:
> Standard indentation of arguments.
> I use right blank space to displace the last table, in order to make the arguments alining. For example:
> 
> old:
> extern void test_fun(struct list_head *new,
> 			struct list_head *prev,
> 			struct list_head *next);
> new:
> extern void test_fun(struct list_head *new,
> 		     struct list_head *prev,
> 		     struct list_head *next);

I think, there is no "standard" on this. I personally do prefer indentation by tabs.
