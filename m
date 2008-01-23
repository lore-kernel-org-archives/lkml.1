Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYAWXs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYAWXs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 18:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYAWXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 18:48:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbYAWXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 18:48:49 -0500
Date: Wed, 23 Jan 2008 23:46:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcin Gil <marcin.gil@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080123234639.025cc859@lxorguk.ukuu.org.uk>
In-Reply-To: <200801232323.36187.marcin.gil@gmail.com>
References: <200801232323.36187.marcin.gil@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have SATA drive connected to SATA0 and Maxtor IDE drive + DVD burner 
> connected to single IDE slot.
> 
> Booting this kernel off the SATA drive works perfectly, however the IDE drive 
> is not found/put into /dev. However the DVD is properly recognized and 
> created as sr0.
> 
> Is this known problem? I've looked all over google and found out that people 
> have problems with CD/DVD drives with pata_jmicron but in my case DVD is 
> working ok but HDD is not.
> 
> Is there a solution for this or can I give you more information to help me 
> solve this?

The output of dmesg after the boot would be a good start
