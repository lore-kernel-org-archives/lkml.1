Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYGRMhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYGRMhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbYGRMhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:37:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:6306 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbYGRMhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mpLhXzAWYCRuEoeeaMPNAhFPuiJTDrJmlzNM0pWPl68VkBxCBqgB7SeGiWSua5IeQr
         +3dqlkImy6bvQDD5k/okhE4+H9YdC+Qz5lfhLG+pQbBBeLrhNTTva3fVe0ZFL1ppgjVx
         29YxxJFqWF6jsIk1eHfmB3PMiuCyMteENy8gg=
Message-ID: <d58509a80807180537h32fec20ci21aee613b4ab7175@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:37:38 +0100
From: "Robert Lougher" <rob.lougher@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Squashfs-devel] Squashfs mainlining status?
Cc: "Peter Korsgaard" <jacmet@sunsite.dk>,
       "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       squashfs-devel@lists.sourceforge.net,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807180808400.6102@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
	 <48460906.2080205@lougher.demon.co.uk>
	 <87od6h7d7l.fsf@macbook.be.48ers.dk>
	 <Pine.LNX.4.64.0807171729450.29859@vixen.sonytel.be>
	 <d58509a80807170847p6ef05a8av96b6c8828a33821@mail.gmail.com>
	 <Pine.LNX.4.64.0807180808400.6102@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 18, 2008 at 7:14 AM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:

> If there are good reasons for breaking compatibility, we're more than happy to
> accept that. Don't you think it would be a good idea to explain them to the
> readers of the squashfs-devel mailing list?
>
> Phillip, can you please elaborate? Many thanks in advance!
>

We need to wait for Phillip to reply for the details.  But my
understanding is that Phillip is using this as an opportunity to clean
up the layout and to remove limitations.  This may give Squashfs an
easier ride in mainlining reviews, and once Squashfs is mainlined
layout changes may become much more difficult, so it's wise to do it
now.

Rob.

> With kind regards,
>
> Geert Uytterhoeven
> Software Architect
>
> Sony Techsoft Centre Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
>
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@eu.sony.com
> Internet: http://www.sony-europe.com/
>
> A division of Sony Europe (Belgium) N.V.
> VAT BE 0413.825.160 · RPR Brussels
> Fortis 293-0376800-10 GEBA-BE-BB
