Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbXGTDJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbXGTDJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXGTDJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:09:05 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52926 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXGTDJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:09:04 -0400
Date: Fri, 20 Jul 2007 05:22:36 +0200
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: asm-offsets
Message-ID: <20070720032236.GB475@flower.upol.cz>
References: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org> <E1IBdoz-0005Ol-6b@flower> <1184895253.10380.227.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184895253.10380.227.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 11:34:13AM +1000, Rusty Russell wrote:
> On Thu, 2007-07-19 at 23:46 +0200, Oleg Verych wrote:
> > > This is the structure offsets required by lg.ko's switcher.S.
> > >
> > > Unfortunately we don't have infrastructure for private asm-offsets
> > > creation.
> > 
> > I did asm-offsets build rewrite RFC caled asm-values more than four week
> > ago: <http://mid.gmane.org/20070612234558.648949000@flower.upol.cz>
> 
> Indeed, but you're poking the wrong person.  Sam needs to ack or fwd...

Even busy people can say something about proposed design of that
rewrite, so work will not stall like this. But lost message is another
case of course.

Patches were spit with one being example of application for lguest.

Thus i did group reply to that merged patch after reading its log :)
____

