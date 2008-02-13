Return-Path: <linux-kernel-owner+w=401wt.eu-S1762369AbYBMUAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762369AbYBMUAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYBMUAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:00:09 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50277 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbYBMUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:00:07 -0500
Date: Wed, 13 Feb 2008 21:59:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Compiler for mn10300?
Message-ID: <20080213195951.GA27391@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can I get a compiler suitable for mn10300?

An svn gcc configured for mn10300-linux gives me:

<--  snip  -->

...
  CC      arch/mn10300/kernel/asm-offsets.s
cc1: error: unrecognized command line option "-mmem-funcs"
make[2]: *** [arch/mn10300/kernel/asm-offsets.s] Error 1

<--  snip  -->

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

