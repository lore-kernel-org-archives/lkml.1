Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZJAKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZJAKLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZJAKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:11:30 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:43569 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbZJAKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:11:30 -0400
Date: Thu, 1 Oct 2009 12:11:19 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Message-ID: <20091001101118.GA2904@dis.manty.net>
References: <20090930110529.GA3676@dis.manty.net>
 <20090930110529.GA3676@dis.manty.net>
 <20090930235709.43ff1255.akpm@linux-foundation.org>
 <200910011026.17510.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011026.17510.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In previous kernels the code would not dump, but still fail and print the 
> request flags, identified by "ide_do_rw_disk - bad command", to the kernel 
> log.
> Manty: Have you ever seen such messages with previous kernels?

Not at all.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
