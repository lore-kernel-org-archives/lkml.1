Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbXHXKib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbXHXKib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXHXKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:38:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32803 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbXHXKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:38:22 -0400
Date: Fri, 24 Aug 2007 11:46:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Drebes <lists-receive@programmierforen.de>
Cc: postfail@hushmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: Ideas on column length in kernel "problem"?
Message-ID: <20070824114611.7b17cafd@the-village.bc.nu>
In-Reply-To: <200708241231.52767.lists-receive@programmierforen.de>
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
	<200708241231.52767.lists-receive@programmierforen.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is also a matter of conding style. Documentation/CodingStyle 
> says:
> 
> "The limit on the length of lines is 80 columns and this is a hard limit."

As has repeatedly been stated this is a bug in Documentation/CodingStyle
and bears no resemblence to reality. 

