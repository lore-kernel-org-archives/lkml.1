Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0BLIZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:25:46 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56433 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0BLIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SxbHnfgpYTHs9PtUhFnWuqzgRkO3GkRk+G+NOR1gUUfQO1UNM1x8LmzKnlDlptH1h3
         K9HYLwKi5Anwi8cSe4nJvNCwZsyZ5kHAq0g7iUUThZfWbQLi3DI/wtA3aXLfI/wA90rp
         resS1NaekbcoRZSTobXyKMQILvuuVw166+8Zo=
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4B6885FA.80509@gmail.com>
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com>
	 <4B687F77.5020409@wpkg.org>  <4B6885FA.80509@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 09:25:39 +0100
Message-ID: <1265963139.2484.3.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-02-02 at 12:07 -0800, Justin P. Mattock wrote:
> On 02/02/10 11:39, Tomasz Chmielewski wrote:
> > On 02.02.2010 20:37, Justin P. Mattock wrote:
> >> apologize for top posting(didn't want to cut dmesg), can this be
> >> reproduced easily?
> >> if so are you able to bisect this?
> >
> > I can reproduce it every week or so, with several reboots daily.
> >
> > Sometimes I can reboot for a few hours in a row, and it boots up
> > correctly each time.
> >
> > So I doubt it's easily bisectable.
> >
> >
> 
> shoot!! you can probably go with the bisect
> but probably wont hear from you until a month or so(given this takes a 
> week to reproduce).
> I've been hitting some odd thing here similar to what
> you have,(stuck during boot right at the CPU*) but probably every 
> two/three months.
> (from what I've read it seems some cpupowermgmnt.kext thing getting 
> mixed up over here(iMac));
> 
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi all! In this discussion I can say that Ubuntu kernel 2.6.31-17-generic
Boots well on my DELL studio 1557 (core i7 powered).

-- 
Alberto!

