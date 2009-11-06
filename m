Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZKFSwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZKFSwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbZKFSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:52:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35197 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207AbZKFSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aR/1KmWj35PFPt/BIs201TEHKtwWxLezlYMUD6OKPS3leEikf4BMP4R0QTQ4XE+OZf
         gGPTSKi6wI9XWuAvCAiOPvcAdDBAUsGneU+50I1jCCkKMbszSYFUrAngIhY10obBsnlc
         JUPiw8YQzKQwO1WuMwkv0FP+06PdYIlMddZv4=
MIME-Version: 1.0
In-Reply-To: <4185.1257523499@turing-police.cc.vt.edu>
References: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
	 <4185.1257523499@turing-police.cc.vt.edu>
Date: Fri, 6 Nov 2009 20:52:43 +0200
Message-ID: <9b2db90b0911061052x55324988i356129ed588ea44a@mail.gmail.com>
Subject: Re: [PATCH] nconfig v5
From: Nir Tzachar <nir.tzachar@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/09, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 06 Nov 2009 10:36:54 +0200, nir.tzachar@gmail.com said:
> > Building on menuconfig, this patch implements a more modern look interface using
> > ncurses and ncurses' satellite libraries (menu, panel, form).
>
> What is the minimum release of ncurses needed?  Some of us silverbacks have
> bad memories of twisty little mazes of ncurses releases, all incompatible. ;)

I have not considred this. I have used ncurses 5.6 on gentoo and
successfully compiled on ubuntu karmic koala, though I don't remember
the exact version ubuntu have.

As I don't have access to any platform other than linux, I cannot test
other versions. I would gladly appreciate your input if you can try it
on other platforms.
