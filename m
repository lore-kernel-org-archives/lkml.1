Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CHCIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:08:52 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56075 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CHCIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lTG+4m0ptXwAtDdUgBnwlC4d2Hd2paT7Tua+pSRyf0XsJVdfiopOhlXdx4dKo+5ixa
         sjfd63yWgmOFJD3e7euJoSzRbHhVwvAc/RUqiTyUM8YBxjNzCA6BZtp/ww8j+aCc4Do2
         Y4PsMF6UloDaQmaifd4yN1sOaD05ZBKpIlFn0=
MIME-Version: 1.0
In-Reply-To: <1267780845-10547-1-git-send-email-jslaby@suse.cz>
References: <4B90CBE5.9090102@viscovery.net>
	 <1267780845-10547-1-git-send-email-jslaby@suse.cz>
Date: Mon, 8 Mar 2010 10:08:46 +0800
Message-ID: <2375c9f91003071808n64bf5ddav4a5eeb6e73158d4@mail.gmail.com>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Johannes Sixt <j.sixt@viscovery.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 5:20 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> linux entry in .gitignore means that everything in include/linux/
> gets ignored with git 1.7.
>
> Prepend a slash to entries which are toplevel to avoid that

New change in git 1.7?
