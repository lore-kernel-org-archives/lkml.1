Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYJORrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYJORrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJORrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:47:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46375 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751434AbYJORrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:47:09 -0400
Date: Wed, 15 Oct 2008 18:46:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] patch to 2.6.27 fix build rpm
Message-ID: <20081015184652.3a935e6f@lxorguk.ukuu.org.uk>
In-Reply-To: <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
References: <20081015172412.GB20222@localhost>
	<E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 23:37:26 +0600
Евгений Маначкин  <sfstudio@mail.ru> wrote:

> From: Evgeniy Manachkin <sfstudio@mail.ru>
> Subject: [PATCH] mkspec - fix build rpm
> 
> This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
> In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
> This is patch fix it this error.
> 
> Sorry my English.
> 
> Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>

Acked-by: Alan Cox <alan@redhat.com>

This should IMHO go straight into both upstream and 2.6.27.x as it is a
regression fix.

Alan
