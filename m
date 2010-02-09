Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0BICXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:23:32 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56229 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0BICXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p/uEcdFu65Mi1KPWF36obMKapVlOWC6EL0KwtSlS+2uyAFkcvhkUFH1nFjt0xvcEa3
         8kGLFBevE8djFMt1iviODMGRr2/jvoR/dyqYscU41BHkGO6DGtcSmpZIpF3QxNrmArTo
         mlTPhw9wDghwJErAaljPFWO/c0QtJelxArzzg=
MIME-Version: 1.0
In-Reply-To: <45c77aec1002081047t48ff5d9dp31c4b7352f61758e@mail.gmail.com>
References: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
	 <d45a3acc1002071414q318edea3m38f6d5ddbbd841bc@mail.gmail.com>
	 <45c77aec1002081013q2b07cb7flbd827a977ed51d4c@mail.gmail.com>
	 <20100208184338.GA17495@emergent.ellipticsemi.com>
	 <45c77aec1002081047t48ff5d9dp31c4b7352f61758e@mail.gmail.com>
Date: Tue, 9 Feb 2010 10:23:29 +0800
Message-ID: <2375c9f91002081823r1e7ed07fi14e4bb41c6faea8b@mail.gmail.com>
Subject: Re: Possible bug in insmod or the kernel?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Larry Homes <larr.homes@gmail.com>
Cc: andrew hendry <andrew.hendry@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 2:47 AM, Larry Homes <larr.homes@gmail.com> wrote:
> That was it. The shell was eating the quotes. Thanks alot!
>

When you met quote problems like this, just test them with echo. ;)
In this case, try:

 echo name="john smith"

Hope this helps.
