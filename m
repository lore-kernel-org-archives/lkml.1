Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0BKJlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:41:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42806 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab0BKJlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:41:47 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Christoph Hellwig <hch@lst.de>
Cc: roland@redhat.com, oleg@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/2] Blackfin: use generic ptrace_resume code
Date: Thu, 11 Feb 2010 04:43:07 -0500
Message-Id: <1265881389-26925-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100202185907.GE3630@lst.de>
References: <20100202185907.GE3630@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the changes I'm going to be pushing out for 2.6.34.  They aren't
trivial to rebase, so I'm keeping them in my tree rather than pushing as
part of set through another.  They aren't dependent on anything pending
anyways (seem to work fine on top of 2.6.32.x).
