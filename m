Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYGVIet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYGVIet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYGVIem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:34:42 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:40361 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYGVIel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:34:41 -0400
Date: Tue, 22 Jul 2008 10:34:36 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Julia Lawall <julia@diku.dk>
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 6/7] drivers/video: Release mutex in error handling code
Message-ID: <20080722083436.GB10834@localhost.localdomain>
References: <Pine.LNX.4.64.0807210958320.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.64.0807210958320.24625@ask.diku.dk>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 09:58:55AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The mutex is released on a successful return, so it would seem that it
> should be released on an error return as well.
... 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
