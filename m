Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXFVXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXFVXI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXFVXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:08:39 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48770 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbXFVXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:08:39 -0400
Message-ID: <467C559B.6050208@gmail.com>
Date: Sat, 23 Jun 2007 01:04:59 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: "H. Peter Anvin" <hpa@zytor.com>, Bart Trojanowski <bart@jukie.net>,
       linux-kernel@vger.kernel.org
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
References: <8bFEz-3B4-39@gated-at.bofh.it> <8c6EE-4Jj-5@gated-at.bofh.it> <8yGrK-4vX-7@gated-at.bofh.it> <8yRnb-4XE-23@gated-at.bofh.it> <E1I1s6z-0000yc-MF@be1.lrz>
In-Reply-To: <E1I1s6z-0000yc-MF@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2007 01:00 AM, Bodo Eggert wrote:

> The real mode on i386+ can actually access the whole 4GB address range
> due to a former-bug-now-feature in the i386+.

Generally called "unreal mode". Yes, sure. Just a hack though.

Rene.
