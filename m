Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZKORD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZKORD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 12:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZKORD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 12:03:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34404 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752293AbZKORD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 12:03:58 -0500
Date: Sun, 15 Nov 2009 17:05:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Polovov <andrey.polovov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting HDD serial in kernel space
Message-ID: <20091115170556.460ea02d@lxorguk.ukuu.org.uk>
In-Reply-To: <4B000A4C.30103@gmail.com>
References: <4AFE95DE.3070308@gmail.com>
	<4B000A4C.30103@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009 17:03:56 +0300
Andrey Polovov <andrey.polovov@gmail.com> wrote:

> Andrey Polovov:
> 
> > How can I do it in kernel space (it is one hdd in machine, plugged with
> > SATA)?
> 
> What I need is a small piece of code that can help me in getting a list
> (ata_device array?) of plugged HDDs and their serial numbers.

That wasn't the question I asked. The question I asked is "what are you
trying to do". You request seems rather odd, especially to try and do in
kernel space, so if we understood what you were trying to do it might
make more sense and easier to suggest the best way to approach it.

Alan
