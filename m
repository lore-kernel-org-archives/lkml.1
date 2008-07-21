Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYGUMrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYGUMrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYGUMq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:46:58 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58115 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYGUMq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:46:58 -0400
Date: Mon, 21 Jul 2008 14:46:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: asm-x86/processor-flags.h, CONFIG_* leaks
Message-ID: <20080721124656.GA28618@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


asm-x86/processor-flags.h is an exported header,
via 'make headers_install_all'

Please move X86_VM_MASK inside __KERNEL__


Olaf

