Return-Path: <linux-kernel-owner+w=401wt.eu-S2993084AbXCIIW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993084AbXCIIW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993086AbXCIIW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:22:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:34412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993084AbXCIIW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:22:56 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Amit Choudhary <amit2030@gmail.com>
Subject: Re: [PATCH] [REVISED] drivers/media/video/stv680.c: check kmalloc() return value.
Date: Fri, 9 Mar 2007 09:23:10 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070308231932.f263f887.amit2030@gmail.com>
In-Reply-To: <20070308231932.f263f887.amit2030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703090923.10412.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 08:19 schrieb Amit Choudhary:
> Description: Check the return value of kmalloc() in function stv680_start_stream(), in file drivers/media/video/stv680.c.

If you are making usb patches, please send them to the usb list
and maintainers. Secondly, against which kernel is this? It won't
apply to the newest kernel. If you are making patches for the stable
series, say so.

	Regards
		Oliver
