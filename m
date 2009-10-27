Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbZJ0VbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbZJ0VbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbZJ0VbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:31:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53175 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932440AbZJ0VbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:31:13 -0400
Date: Tue, 27 Oct 2009 21:32:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: Greg KH <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091027213242.0c2494c5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	<20091023161006.GA1580@ucw.cz>
	<20091026165518.GE2792@tuxdriver.com>
	<alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
	<20091026184734.GA21591@suse.de>
	<alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
	<20091027140812.GC17208@suse.de>
	<alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> while I definantly agree that this driver is unlikly to have many users, 
> unless it is known broken (which David Miller has stated that it is, but 
> had not been mentioned previously in this thread), how can you know that 
> the number of users has dropped below 1?

By the fact it never turns up in bugzilla, in kernel questions or
in google - and then by deleting it and checking for screaming noises.

Do you have a better testing procedure ?
