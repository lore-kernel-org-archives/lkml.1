Return-Path: <linux-kernel-owner+w=401wt.eu-S966327AbXEVQmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966327AbXEVQmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbXEVQmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:42:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20553 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbXEVQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:42:30 -0400
Date: Tue, 22 May 2007 09:41:08 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Delay writing 0's after llseek until write
Message-ID: <20070522164108.GV364@mami.zabbo.net>
References: <20070521230021.GD3621@us.ibm.com> <20070521210708.67d365dc.akpm@linux-foundation.org> <20070522145124.GA3616@us.ibm.com> <29495f1d0705220801v50e53f2dl24f9b198dd31c39c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0705220801v50e53f2dl24f9b198dd31c39c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, I believe Andrew's point was that critical information for Joe
> Enduser (and Joe Patch-Ho) was lacking in the original changelog.

and don't forget Joe eCryptfs-Maintainer-2-Years-In-The-Future.

- z
