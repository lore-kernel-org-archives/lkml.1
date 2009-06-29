Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbZF2QcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbZF2QcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZF2QcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:32:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbZF2QcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:32:06 -0400
Date: Mon, 29 Jun 2009 17:33:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090629173301.2a99a02e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090629162853.GB3461@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	<6JJ2m5kyucK.A.D2D.VJASKB@chimera>
	<20090629154119.2c61f234@lxorguk.ukuu.org.uk>
	<20090629162853.GB3461@localdomain.by>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG is still here...

> kernel: [ 7331.719657] EIP is at _spin_unlock_irqrestore+0x16/0x30

Which doesn't reschedule - sorry at this point I can't help you any
further. The traces make no sense.

