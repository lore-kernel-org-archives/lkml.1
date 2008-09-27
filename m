Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYI0VYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYI0VYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 17:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYI0VX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 17:23:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:49228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYI0VXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 17:23:55 -0400
Message-ID: <48DEA40D.40709@kernel.org>
Date: Sun, 28 Sep 2008 06:22:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita>
In-Reply-To: <20080925081848.GB2305@anita>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Sep 2008 21:23:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Tejun, sorry for misspelling your name as Tijo :-/
> 
> Do I hit your spamfilter with my KSYMOOPS enabled debug outputs or some
> sort of that? If not, sorry for the inconvenience and take your time.

Sorry about lack of response.  I was on vacation after a series of
conferences.  There's a bug entry for this problem and I just posted a
patch.

  http://bugzilla.kernel.org/show_bug.cgi?id=11615

Can you please try the patch attached there and post the result there?

Thanks.

-- 
tejun
