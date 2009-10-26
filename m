Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZJZR17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZJZR17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZJZR16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:27:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44498 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754093AbZJZR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:27:56 -0400
Date: Mon, 26 Oct 2009 17:29:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026172932.3427fa9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091026172434.GI25725@elf.ucw.cz>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	<20091023161006.GA1580@ucw.cz>
	<20091026165518.GE2792@tuxdriver.com>
	<20091026172434.GI25725@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This has been discussed recently as an alternative for unmaintained
> > drivers.  I suspect this is better than adding a note to a file that
> > no one reads...
> 
> There are other alternatives, like printk() in module_init...

Put it in feature removal for tomrrow wait until midnight and then submit
a deletion patch. Like anyone cares about the strip driver
