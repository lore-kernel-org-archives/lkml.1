Return-Path: <linux-kernel-owner+w=401wt.eu-S1765113AbXJFTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765113AbXJFTSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXJFTSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:18:42 -0400
Received: from 1wt.eu ([62.212.114.60]:2800 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJFTSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:18:41 -0400
Date: Sat, 6 Oct 2007 21:18:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Security leak in kernel
Message-ID: <20071006191837.GR10199@1wt.eu>
References: <6101e8c40710061058v32488b36m43073d946519aa98@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40710061058v32488b36m43073d946519aa98@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 07:58:52PM +0200, Oliver Pinter wrote:
> Hi All!
> 
> this: http://www.milw0rm.com/exploits/4460http://www.milw0rm.com/exploits/4460
> 
> exploit is fixed in kernel or not? this find I now..

Yes it's fixed by commit 176df2457 on 2007/09/21. It was CVE-2007-4573.

Regards,
Willy

