Return-Path: <linux-kernel-owner+w=401wt.eu-S2992767AbXCBXpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992767AbXCBXpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992765AbXCBXp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:45:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992767AbXCBXp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:45:29 -0500
Date: Sat, 3 Mar 2007 00:48:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] char/epca.c remove unused function (was: Re:
 2.6.21-rc2-mm1)
Message-ID: <20070303004837.016ecdb9@lxorguk.ukuu.org.uk>
In-Reply-To: <45E8ADB3.1010308@googlemail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<45E8ADB3.1010308@googlemail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 00:05:23 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisał(a):
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> 
> Please consider this patch for inclusion in >= 2.6.22.
> 
> "drivers/char/epca.c:2741: warning: 'get_termio' defined but not used"

Acked-by: Alan Cox <alan@redhat.com>
