Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZHFPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZHFPlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZHFPlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:41:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48959 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbZHFPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:41:43 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
From: Andi Kleen <andi@firstfloor.org>
References: <1249511439-31088-1-git-send-email-sage@newdream.net>
	<1249511439-31088-2-git-send-email-sage@newdream.net>
	<1249511439-31088-3-git-send-email-sage@newdream.net>
	<1249511439-31088-4-git-send-email-sage@newdream.net>
	<1249511439-31088-5-git-send-email-sage@newdream.net>
	<1249511439-31088-6-git-send-email-sage@newdream.net>
	<1249511439-31088-7-git-send-email-sage@newdream.net>
	<1249511439-31088-8-git-send-email-sage@newdream.net>
	<1249511439-31088-9-git-send-email-sage@newdream.net>
	<1249511439-31088-10-git-send-email-sage@newdream.net>
	<1249511439-31088-11-git-send-email-sage@newdream.net>
	<1249511439-31088-12-git-send-email-sage@newdream.net>
	<1249511439-31088-13-git-send-email-sage@newdream.net>
	<1249511439-31088-14-git-send-email-sage@newdream.net>
	<1249511439-31088-15-git-send-email-sage@newdream.net>
	<1249511439-31088-16-git-send-email-sage@newdream.net>
	<1249511439-31088-17-git-send-email-sage@newdream.net>
	<1249511439-31088-18-git-send-email-sage@newdream.net>
Date: Thu, 06 Aug 2009 17:41:42 +0200
In-Reply-To: <1249511439-31088-18-git-send-email-sage@newdream.net> (Sage Weil's message of "Wed,  5 Aug 2009 15:30:37 -0700")
Message-ID: <87prb9hrux.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:

> A few Ceph ioctls for getting and setting file layout (striping)
> parameters.

FWIW I reviewed this file and found nothing bad in it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
