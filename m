Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbYCUVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbYCUVqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYCUVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:46:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755872AbYCUVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:46:42 -0400
Date: Fri, 21 Mar 2008 21:31:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Madhou <madh2001@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: shell outputs anything typed when the kernel thinks@100%
Message-ID: <20080321213108.1bb491ef@core>
In-Reply-To: <200803212211.43833.madh2001@gmail.com>
References: <200803212211.43833.madh2001@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The time that the kernel takes for checking usernames is about one second on 
> my laptop which is equipped with an intel centrino 1,7GHz.

The kernel doesn't do anything with usernames. Most likely your user
space login programs are configured with an intentional delay to stop
dictionary attacks.
