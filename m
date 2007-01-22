Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXAVUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXAVUo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbXAVUo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:44:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50113 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbXAVUo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:44:57 -0500
Date: Mon, 22 Jan 2007 12:44:42 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, tom@dbservice.com,
       bwalle@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-Id: <20070122124442.9eed5fd9.akpm@osdl.org>
In-Reply-To: <9e0cf0bf0701221231sc638114j2f0123650ffc14ea@mail.gmail.com>
References: <20070118125849.441998000@strauss.suse.de>
	<20070118130028.719472000@strauss.suse.de>
	<20070118141359.GB31418@flint.arm.linux.org.uk>
	<45AF92E7.50901@dbservice.com>
	<20070118152326.GC31418@flint.arm.linux.org.uk>
	<20070122115650.d0be8bd3.akpm@osdl.org>
	<9e0cf0bf0701221231sc638114j2f0123650ffc14ea@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 22:31:48 +0200
"Alon Bar-Lev" <alon.barlev@gmail.com> wrote:

> Hello Andrew,
> 
> Can I do anything more in order to be closer to merge?

Avoid top-posting? ;)

> Some general comments... or should I CC other people etc...
> I submitted this several times but got almost no architecture to ACK.
> 
> I just don't know how we can progress with this issue... All we wanted
> is to break the 256 limit in x86...

yes, the patches looked reasonable-looking.  But iirc they were against
2.6.19 which is prehistoric.  Please redo and resend against a development
kernel.

