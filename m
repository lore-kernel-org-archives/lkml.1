Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZEEVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZEEVqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZEEVqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:46:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZEEVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:46:14 -0400
Message-Id: <20090505213203.797397821@suse.de>
User-Agent: quilt/0.47-14.10
Date: Tue, 05 May 2009 23:32:03 +0200
From: jblunck@suse.de
To: Arnd Bergmann <arndb@de.ibm.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] spufs: Minor cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

here are some minor cleanups that I think are worth doing. I had them in my
union mount queue because I had some changes to lookup_create() planned.

Cheers,
Jan

