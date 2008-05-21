Return-Path: <linux-kernel-owner+w=401wt.eu-S934461AbYEUGaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461AbYEUGaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbYEUGaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:30:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:45768 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760667AbYEUGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=K2R944QjBjy23d1c3+ZJ8BS9TyRNK0Ow5QoiljNvPW6H4VaxZarGU5j+cE6Tp8CLH5hVGnkAH37gLELpKHTj2AG+I7dLVPHuDsOAQVnB8A/Y9kG+VR5V1FIgbkT9bVRPwrTNqSL9SSSjh/RIqUThSpWdz4bcFR3QPrnzCY5X2Mg=
Date: Wed, 21 May 2008 14:29:57 +0800
From: Jianjun Kong <kongjianjun@gmail.com>
To: Jike Song <albcamus@gmail.com>
Cc: sam@ravnborg.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [.gitignore] match ncscope.out
Message-ID: <20080521062957.GB7748@ubuntu>
References: <4834CAFE.2070607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834CAFE.2070607@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:23:10AM +0800, Jike Song wrote:
> From e8e67fca3f9227b612a59d8afd0464222231e362 Mon Sep 17 00:00:00 2001
> From: Jike Song <albcamus@gmail.com>
> Date: Tue, 20 May 2008 16:15:05 +0800
> Subject: [PATCH] [.gitignore] match ncscope.out
>
> Sometimes I got this:
>
>    $ git-status
>    {snip}
>    # On branch master
>    # Untracked files:
>    #   (use "git add <file>..." to include in what will be committed)
>    #
>    #       ncscope.out
>    nothing added to commit but untracked files present (use "git add" to 
> track)

Yes, there is also another two files, ncscope.in.out and ncscope.po.out

kongove@ubuntu:~/git/linux-2.6$ git commit -a
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       ncscope.in.out
#       ncscope.po.out

-- 
| Feel Earthquake, Feel Fright!
| ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| Jianjun Kong | www.kongove.cn
| Xi'an Institute of Post & Telecommunications
