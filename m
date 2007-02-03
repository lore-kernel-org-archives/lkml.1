Return-Path: <linux-kernel-owner+w=401wt.eu-S1946446AbXBCPae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946446AbXBCPae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946455AbXBCPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:30:34 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53407 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1946446AbXBCPad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:30:33 -0500
Message-ID: <370516630.03363@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 3 Feb 2007 23:31:45 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-ID: <20070203153145.GA3980@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management <linux-mm@kvack.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070202155232.babe1a52.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202155232.babe1a52.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:52:32PM -0800, Andrew Morton wrote:
> Bugfixes come first, so I will drop readahead and fsaio and git-block to get
> this work completed if needed - please work agaisnt mainline.

OK with readahead.

There are too much fixes in the series.  I'd like to fold them up and
update some change logs. And then there would be one more update.

Regards,
Wu
