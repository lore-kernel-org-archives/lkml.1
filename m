Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZCOP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZCOP5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZCOP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:57:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:41881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZCOP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:57:29 -0400
Date: Sun, 15 Mar 2009 08:58:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Yoshiharu Mori <ymori4480@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DMAR ERROR by nVidia video card
Message-ID: <20090315085823.56e764dc@infradead.org>
In-Reply-To: <d5dec53b0903150504v9843fefr939f0a0cbc8a300f@mail.gmail.com>
References: <d5dec53b0903150504v9843fefr939f0a0cbc8a300f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Mar 2009 21:04:21 +0900
Yoshiharu Mori <ymori4480@gmail.com> wrote:

> Hi
> 
> I enabled DMAR by kernel parameter, and started X windows.
> The following error message is reported forever.
> Is this driver's issue?

yeah it looks like the driver isn't using the DMA mapping API correctly.
You filed this bug in the wrong forum though, this isn't the nvidia
forum, and you're using their binary driver, nothing we can do to help
you.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
