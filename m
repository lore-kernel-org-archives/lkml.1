Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZANKPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZANKPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZANKPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:15:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33817 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753981AbZANKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:15:03 -0500
Date: Wed, 14 Jan 2009 10:15:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux kernel without file system
Message-ID: <20090114101521.5364c04d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090114083024.GA30573@frolo.macqel>
References: <20090114083024.GA30573@frolo.macqel>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a way to access devices that does not require a file-system ?

No: but you can run with just your own programs and bits needed loaded
off an initial ramdisk or a romfs image. A better place to ask and learn
is probably the "busybox" list as most people doing this stuff use
busybox for their tools
