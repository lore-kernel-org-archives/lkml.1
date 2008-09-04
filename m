Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYIDB3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYIDB3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 21:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYIDB3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 21:29:25 -0400
Received: from topsns2.0.225.230.202.in-addr.arpa ([202.230.225.126]:26211
	"EHLO topsns2.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbYIDB3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 21:29:24 -0400
Date: Thu, 04 Sep 2008 10:29:21 +0900 (JST)
Message-Id: <20080904.102921.144195172.nemoto@toshiba-tops.co.jp>
To: david@fries.net
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, netdev@vger.kerne.org
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080831204545.GA28469@spacedout.fries.net>
References: <20080830022749.GF17528@spacedout.fries.net>
	<20080830.235226.108118828.anemo@mba.ocn.ne.jp>
	<20080831204545.GA28469@spacedout.fries.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 15:45:45 -0500, David Fries <david@fries.net> wrote:
> This patch is the changes since [PATCH 1/2], if it looks good I'll
> submit the git changeset next.

Thanks, it looks good for me.

---
Atsushi Nemoto
