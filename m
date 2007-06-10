Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbXFJTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbXFJTnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFJTnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:43:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:38802 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbXFJTnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=c4gFcl3dHJLaRE/gmPoBgIdvoBtpeQQI2rv/9abGrP0PuNlN9t8biY6GBH3C5Zd4BzTnMHo6+gOXNm82PHxXgP0NhI8E02uK3TDgc5jVU/a9B+tfxMG93J+IeY7C5HaEJFKpbf5VHAEme8E6tLHvqgeaRZzgFantj1aFJDsGzm8=
Date: Sun, 10 Jun 2007 21:41:38 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO
 translated into Japanese]
Message-Id: <20070610214138.3d17be8a.diegocg@gmail.com>
In-Reply-To: <20070610175228.GA28947@uranus.ravnborg.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
	<9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
	<20070610162221.GA12830@suse.de>
	<20070610175228.GA28947@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 10 Jun 2007 19:52:28 +0200, Sam Ravnborg <sam@ravnborg.org> escribió:

> I advocated that they should stay out back then.
> But on the other hand I do not see it causing much troubles
> having scripts/kconfig/po/da.po etc araound.
> 
> Any opinion about the .po files?

These days the configuration menus are not something that users need to
read, they're more like a developer tool. IMO there's not much value in it,
because the people who read it already know english most of the times.
