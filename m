Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYKQB5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYKQB5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYKQB5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:57:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:36224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbYKQB5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:57:09 -0500
Message-ID: <4920CF57.4070908@kernel.org>
Date: Mon, 17 Nov 2008 10:56:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.28-rc5: Reported regressions from 2.6.27
References: <Pine.LNX.4.44L0.0811161527410.14867-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0811161527410.14867-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Nov 2008 01:56:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sun, 16 Nov 2008, Rafael J. Wysocki wrote:
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
>> Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
>> Submitter	: Tejun Heo <tj@kernel.org>
>> Date		: 2008-10-26 9:46 (22 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
>> References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4
> 
> I believe this was fixed by commit 
> 2920ebbd65f3e80c318adf5191ac0987142bda80.  Tejun, isn't that right?

Yes, that's right.

Thanks.

-- 
tejun
