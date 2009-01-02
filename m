Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZABLn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZABLn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZABLnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:43:06 -0500
Received: from ns.suse.de ([195.135.220.2]:57473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbZABLnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:43:05 -0500
From: Marcus Meissner <meissner@suse.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
In-Reply-To: <20090102082824.GA4212@suse.de.suse.lists.linux.kernel>
X-Newsgroups: suse.lists.linux.kernel
User-Agent: tin/1.8.2-20060425 ("Shillay") (UNIX) (Linux/2.6.27.8-1-ppc64 (ppc64))
Message-Id: <20090102114302.78965304C5@grape.suse.de>
Date: Fri,  2 Jan 2009 12:43:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20090102082824.GA4212@suse.de.suse.lists.linux.kernel> you wrote:
> 
> Hm, care to run 'git bisect'?
> 
> Or do you have a simple (or complex) test program that I can run here to
> do the same thing?

Greg, the same issue also happens with libgphoto2 / libusb.

I was pointed to this bug + fix:

	http://article.gmane.org/gmane.linux.usb.general/13442
        http://bugzilla.kernel.org/show_bug.cgi?id=12301

Ciao, Marcus
