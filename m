Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYAANvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYAANvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYAANuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:50:15 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53876 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbYAANuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:50:12 -0500
Date: Tue, 1 Jan 2008 15:49:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Status of the h8300 port?
Message-ID: <20080101134958.GS2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The h8300 port doesn't even compile anymore for some time (the
first compile error you run into was introduced 7 months ago by
commit c728d60455e8e8722ee08312a75f38dd7a866b5e).

Are there any patches in some external tree that should be merged?

Or will anyone work on getting this port back into a usable state in the 
forseeable future?

Otherwise the only reasonable option would be to remove this port from 
the kernel sources since it is dead code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

