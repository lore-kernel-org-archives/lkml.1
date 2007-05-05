Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXEEUiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXEEUiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbXEEUiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:38:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39135 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbXEEUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:38:09 -0400
Date: Sat, 5 May 2007 22:38:05 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: cpufreq_set_policy [arch/powerpc/platforms/cell/cbe_cpufreq.ko] undefined!
Message-ID: <20070505203805.GA6890@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, Andrew Morton wrote:

>  git-cpufreq.patch

ERROR: ".cpufreq_set_policy" [arch/powerpc/platforms/cell/cbe_cpufreq.ko] undefined!

This is also broken in mainline.
