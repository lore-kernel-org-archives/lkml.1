Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYGYX0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYGYX0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGYX0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:26:47 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:45156 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYGYX0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:26:46 -0400
Date: Sat, 26 Jul 2008 02:26:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: virtio header BSD licencing
Message-ID: <20080725232618.GC9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

commit 674bfc23c585b34c42263d73fb51710d49762a23
(virtio: clarify that ABI is usable by any implementations)
added the following to the top of some headers:

  /* This header is BSD licensed so anyone can use the definitions to implement
   * compatible drivers/servers. */

What is "BSD licensed"?
- 4 clause BSD license?
- 3 clause BSD license?
- 2 clause BSD license?
- some other variant?

Please put a proper licence text there.

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

