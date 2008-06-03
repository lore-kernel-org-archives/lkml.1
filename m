Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYFCEa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYFCEa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYFCEaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:30:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34587 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYFCEaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:30:17 -0400
X-AuditID: 0ac90650-ad08dba0000062df-46-4844c8d76fb8
Message-ID: <4844C8CF.8060700@hitachi.com>
Date: Tue, 03 Jun 2008 13:30:07 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
References: <4843CE15.6080506@hitachi.com> 
    <20080602120538.GK30613@duck.suse.cz>
In-Reply-To: <20080602120538.GK30613@duck.suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jan Kara wrote:
> On Mon 02-06-08 19:40:21, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 0/5] jbd: possible filesystem corruption fixes (take 2)
> 
>   Just a small note - repeating the subject in the changelog makes it a bit
> harder for Andrew to merge the patches. Standard merging scripts prepend
> subject of the email to the changelog below and so in your case the message
> would be there twice... Just that you know when you create the patch series
> next time.

Thank you for letting me know.  I'll not do such odd thing next time.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

