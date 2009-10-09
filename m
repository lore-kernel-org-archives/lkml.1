Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbZJICj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbZJICj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZJICj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:39:27 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:49460 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbZJICj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Lv95qhfX2F/6GNVEbYLM2aD6HBFJM1Gje69D/uNgzGHnae6P73Rin+95G6ludUA9xk
         ntkjXrhmTn4cX4PEq6t1yCSu/oN1M2C74188lt7xonY8EApuzUrg/wl5LOg9ng5nZM+m
         OW9X/JBrIwgNljqUKxX7xfgMZHn2eRIera3dY=
Date: Thu, 8 Oct 2009 19:38:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: keyboard under X with 2.6.31
Message-ID: <20091009023844.GA26462@core.coreip.homeip.net>
References: <alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 05:19:25PM -0300, Frédéric L. W. Meunier wrote:
> My keyboard (ABNT2 PS/2) seems to be broken under X with 2.6.31.2. After 
> less than an hour, it starts acting crazy. The first time, all leds 
> turned off and I couldn't type anything. The second time, all leds also 
> turned off, but since it happened while I was pressing the Backspace key 
> to delete text, it continued deleting, like if the key was pressed.
>
> In both cases, the mouse (USB) still works and I can exit X, where the 
> keyboard works. There's nothing in the logs.
>
> No problem with 2.6.30.9. Is it supposed to be a kernel or X bug ?

It would be interestig to see if the same keyboard continues to work in
console... if it does then I'd blame X.

-- 
Dmitry
