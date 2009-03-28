Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZC1P5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZC1P5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZC1P50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:57:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53908 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZC1P5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:57:25 -0400
X-Greylist: delayed 1738 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Mar 2009 11:57:25 EDT
Date: Sat, 28 Mar 2009 16:28:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328162857.57c5372d@the-village.bc.nu>
In-Reply-To: <20090328155837.GA3503@x200.localdomain>
References: <1238251730.2526.2.camel@ht.satnam>
	<20090328150746.GA3268@x200.localdomain>
	<20090328155549.47c9cdc5@the-village.bc.nu>
	<20090328155837.GA3503@x200.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Getting the includes under control is a good thing and saves everyone
> > time.
> 
> Moving #includes up and down is not getting them under control.

Look a bit deeper and youĺl see what is going on (or tell your gcc to log
the include calls and it will become very apparent)
