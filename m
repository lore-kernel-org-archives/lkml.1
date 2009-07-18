Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZGRNxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZGRNxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZGRNxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:53:16 -0400
Received: from fifo99.com ([67.223.236.141]:34512 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZGRNxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:53:15 -0400
Subject: Re: HTC Dream for staging
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090718104126.GC11381@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz>
	 <20090716230042.GB3609@kroah.com> <20090717010157.GA2002@elf.ucw.cz>
	 <20090717011211.GA16704@kroah.com> <20090717120657.GB2192@elf.ucw.cz>
	 <20090717134620.GB1315@kroah.com> <20090717135743.GB19854@elf.ucw.cz>
	 <20090717141440.GA16660@kroah.com>  <20090718104126.GC11381@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 06:53:11 -0700
Message-Id: <1247925191.14209.707.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 12:41 +0200, Pavel Machek wrote:

> (BTW: I do not see the patches in the git tree, yet, and the tree is
> labeled as "junk tree, please ignore". Should I just wait a bit? Or is
> staging maintained outside of git? Or should the description be
> updated?)

Staging is a quilt tree .. In Linux-next Next/Trees has it listed as,

staging         quilt   http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/

I guess it was once a git tree, but was changed over at some point.

Daniel

