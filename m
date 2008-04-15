Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbYDOIOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbYDOIOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYDOIO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:14:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:44220 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYDOIOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kQOldYkVEW3IpcGIC+NcqI8Qp5kV5z1G+Gi2CgZKRhqTwEIj7YDTcn/EgI9SBNdGgNgGmdPxvupp8Ysh56vQonhUeDGG9mRu/ummialHi07XuZGtZt0TL8jHFZLHNgYZCXSFjGbYcQhzycYo0OxXepgm6q/N9U8+CFjszN4AzI0=
Message-ID: <a32f33a40804150114m4ae05749r1f21638ba4e79ce8@mail.gmail.com>
Date: Tue, 15 Apr 2008 10:14:22 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Cc: "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <20080414214653.GB9815@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
	 <200804141400.41319.IvDoorn@gmail.com>
	 <200804142006.51224.carlos@strangeworlds.co.uk>
	 <200804142304.42716.IvDoorn@gmail.com>
	 <20080414214653.GB9815@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:46 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 14 Apr 2008, Ivo van Doorn wrote:
>  > Completely overlooked the patch.
>  > I found it in my archives and just acked it. :)
>
>  Unless you want extra trouble and work on your hands when merge time
>  comes, I would really appreciate a tree with all pending rfkill patches
>  applied to base my work on.   Right now, I am using 2.6.25-rc8-mm2.

I've asked john to push the patch to 2.6.25 as well.

>  May I suggest you open a git tree somewhere that we can use to track the
>  rfkill pending patches that are not in mainline yet? :-)

Sure, not a problem. Let me see from which tree it will be best to branch from.

>  If you don't have a git server in mind already, I suggest http://repo.or.cz

I've an account on kernel.org. :)

Ivo
