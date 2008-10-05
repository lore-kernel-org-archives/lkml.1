Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYJEKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYJEKU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYJEKUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:20:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:43833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYJEKUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:20:16 -0400
Message-ID: <48E8947A.5020608@kernel.org>
Date: Sun, 05 Oct 2008 19:18:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: linux-kernel@vger.kernel.org, lists@ku-gbr.de, bhalevy.lists@gmail.com
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com>
In-Reply-To: <48E890B9.6050307@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Oct 2008 10:20:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> On Sep. 24, 2008, 12:36 +0300, Tejun Heo <tj@kernel.org> wrote:
>> Please apply the attached patch and post the resulting log.  Please
>> don't forget to turn on KALLSYMS.
>>
>> Thanks.
>>
> 
> With commit 4c1eb90a0908c0c60db2169dce08fb672e7582f1 (v2.6.27-rc8),
> I see no spurious EH complete events as I saw with 2.6.27-rc <= 7.

You're on CK804, right?

-- 
tejun
