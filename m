Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYBDU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYBDU3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbYBDU3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:29:08 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4549 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbYBDU3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:29:07 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: 2.6.24-mm1: ppc32: too few arguments to function 'reserve_bootmem'
Date: Mon, 4 Feb 2008 21:29:02 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802042129.03065.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This is from ppc32:

  CC      arch/powerpc/mm/mem.o
arch/powerpc/mm/mem.c: In function 'do_init_bootmem':
arch/powerpc/mm/mem.c:256: error: too few arguments to function 'reserve_bootmem'
arch/powerpc/mm/mem.c:261: error: too few arguments to function 'reserve_bootmem'

Leftover from introduce-flags-for-reserve_bootmem.patch?

Regards,

	Mariusz
