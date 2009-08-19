Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZHSAbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZHSAbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZHSAbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:31:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZHSAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:31:14 -0400
Date: Tue, 18 Aug 2009 20:31:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
In-Reply-To: <4A8B4607.6090303@gmail.com>
Message-ID: <alpine.DEB.2.00.0908182030450.18648@gandalf.stny.rr.com>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
 <4A8B4607.6090303@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Aug 2009, Justin P. Mattock wrote:
> well grub2 sure works o.k.
> the new gfxload is pretty good.
> problem is the screen just says
> [Linux-bzImage etc.....]
> and that's it. (was hoping to make the
> font smaller to reveal the bug).
> 
> at this point the only choice I have is to undo
> commits until I hit the right one.

How come you can not do a git bisect?

It would be faster.

-- Steve

