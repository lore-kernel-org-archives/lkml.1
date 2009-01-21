Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbZAUIUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbZAUIUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZAUITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:19:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:55490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZAUITu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:19:50 -0500
Message-ID: <4976DA9C.7000500@kernel.org>
Date: Wed, 21 Jan 2009 17:19:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232457345-12366-5-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:19:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Remove unused idle_timestamp field from 32-bit.

Dropped.  X86_32 doesn't build.  X86_64 UP doesn't build.  Please at
least do compile testing on all four combinations before sending the
patches.

Thanks.

-- 
tejun
