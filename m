Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYIGWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYIGWKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYIGWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:10:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:44888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYIGWKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:10:40 -0400
Date: Sun, 7 Sep 2008 15:10:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Shane <gnome42@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: warn_on_slowpath at drivers/usb/serial/usb-serial.c:311
Message-ID: <20080907151046.22b5062f@infradead.org>
In-Reply-To: <fa4052ef0809071500y56a3bc2ei15d96fdb1857255c@mail.gmail.com>
References: <fa4052ef0809071500y56a3bc2ei15d96fdb1857255c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2008 18:00:08 -0400
Shane <gnome42@gmail.com> wrote:

> Got several of these messages when I plugged in a usb gps unit. The
> gps unit worked fine.
> 
you;re not the only one fwiw:

http://www.kerneloops.org/search.php?search=serial_write

shows quite a few reports of this

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
