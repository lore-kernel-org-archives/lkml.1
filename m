Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbXIZPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbXIZPzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXIZPzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:55:07 -0400
Received: from [81.2.110.250] ([81.2.110.250]:52132 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752268AbXIZPzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:55:06 -0400
Date: Wed, 26 Sep 2007 17:00:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1: ata3: soft resetting link after STR
Message-ID: <20070926170020.195de7f7@the-village.bc.nu>
In-Reply-To: <20070926153901.GA1746@martell.zuzino.mipt.ru>
References: <20070925205006.GA1766@martell.zuzino.mipt.ru>
	<1190756717.17409.80.camel@chaos>
	<20070926091412.GA1752@martell.zuzino.mipt.ru>
	<1190788997.23376.9.camel@chaos>
	<20070926153901.GA1746@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 19:39:01 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Frequently get these messages after resume from STR,
> (subjectively, first STR is always OK).

Does this occur if you have the acpi support enabled
(libata.noacpi=0)

