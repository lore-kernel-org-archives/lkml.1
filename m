Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYBOFNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYBOFNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYBOFNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:13:37 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:2940 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYBOFNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:13:36 -0500
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix return value in ib_device_register_sysfs()
X-Message-Flag: Warning: May contain useful information
References: <47B4F7F1.1090002@cn.fujitsu.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 14 Feb 2008 21:13:30 -0800
In-Reply-To: <47B4F7F1.1090002@cn.fujitsu.com> (Li Zefan's message of "Fri, 15 Feb 2008 10:24:49 +0800")
Message-ID: <adave4qol8l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2008 05:13:31.0027 (UTC) FILETIME=[814C6E30:01C86F91]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, good catch.  How did you find this bug?

Anyway, thanks, applied.

 - R.
