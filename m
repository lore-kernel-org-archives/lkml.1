Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYJBXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYJBXz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYJBXzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:55:49 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:53605 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbYJBXzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:55:48 -0400
Date: Thu, 2 Oct 2008 19:55:47 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
In-Reply-To: <86802c440810021533v572975e8n40e55009cc2b2d8a@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0810021954330.4688@redclaw.mimosa.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>  <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>  <20081003000314.771b2f68@werewolf.home> <86802c440810021533v572975e8n40e55009cc2b2d8a@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| From: Yinghai Lu <yinghai@kernel.org>

| can you boot with mtrr_cleanup_debug?
| 
| also what is /proc/mtrr with disable_mtrr_cleanup?

Shouldn't mtrr_cleanup_debug show the pre-cleanup MTRR settings?
