Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZGPM1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZGPM1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbZGPM1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:27:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbZGPM1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:27:43 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
From: Andi Kleen <andi@firstfloor.org>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
	<1247693090-27796-2-git-send-email-sage@newdream.net>
	<1247693090-27796-3-git-send-email-sage@newdream.net>
	<1247693090-27796-4-git-send-email-sage@newdream.net>
	<1247693090-27796-5-git-send-email-sage@newdream.net>
	<1247693090-27796-6-git-send-email-sage@newdream.net>
	<1247693090-27796-7-git-send-email-sage@newdream.net>
	<1247693090-27796-8-git-send-email-sage@newdream.net>
	<1247693090-27796-9-git-send-email-sage@newdream.net>
	<1247693090-27796-10-git-send-email-sage@newdream.net>
	<1247693090-27796-11-git-send-email-sage@newdream.net>
	<1247693090-27796-12-git-send-email-sage@newdream.net>
	<1247693090-27796-13-git-send-email-sage@newdream.net>
	<1247693090-27796-14-git-send-email-sage@newdream.net>
	<1247693090-27796-15-git-send-email-sage@newdream.net>
	<1247693090-27796-16-git-send-email-sage@newdream.net>
	<1247693090-27796-17-git-send-email-sage@newdream.net>
	<1247693090-27796-18-git-send-email-sage@newdream.net>
	<1247693090-27796-19-git-send-email-sage@newdream.net>
Date: Thu, 16 Jul 2009 14:27:42 +0200
In-Reply-To: <1247693090-27796-19-git-send-email-sage@newdream.net> (Sage Weil's message of "Wed, 15 Jul 2009 14:24:48 -0700")
Message-ID: <87d480x16p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:

> Some debugging infrastructure, including the ability to adjust the
> level of debug output on a per-file basis.

That is already provided by pr_debug()/DYNAMIC_PRINTK in newer kernels.
You should switch to that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
