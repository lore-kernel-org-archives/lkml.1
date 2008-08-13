Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYHMUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYHMUvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYHMUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:51:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52504 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbYHMUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:51:08 -0400
Date: Wed, 13 Aug 2008 21:33:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alex Chiang <achiang@hp.com>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: tty-kref-modcount oops in linux-next
Message-ID: <20080813213348.68263ad7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080813203438.GT25902@ldl.fc.hp.com>
References: <20080813203438.GT25902@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 14:34:38 -0600
Alex Chiang <achiang@hp.com> wrote:

> Hi Alan,
> 
> Booting the latest linux-next kernel (20080812) on my HP rx6600
> (ia64) results in an oops. This is a SLES10 userspace, but I
> don't know if that matters.

Thanks I pushed a few fixes into the ttydev tree today so hopefully they
are fixed, if not drop me another email and we'll work through your case
as well
