Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYBKWSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYBKWSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYBKWSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:18:36 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47422 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYBKWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:18:35 -0500
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jackm@dev.mellanox.co.il
Subject: Re: [PATCH] mlx4: fix build break
X-Message-Flag: Warning: May contain useful information
References: <adafxw36ntm.fsf@cisco.com> <20080211022257.GA26656@lixom.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 11 Feb 2008 14:18:24 -0800
In-Reply-To: <20080211022257.GA26656@lixom.net> (Olof Johansson's message of "Sun, 10 Feb 2008 20:22:57 -0600")
Message-ID: <adaodanxhlb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2008 22:18:25.0849 (UTC) FILETIME=[056A9A90:01C86CFC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.

Jack, I thought you guys tested the build on powerpc.  How did this
sneak through?
