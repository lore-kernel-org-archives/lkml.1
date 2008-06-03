Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYFCFMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYFCFMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 01:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYFCFLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 01:11:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48784 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYFCFLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 01:11:49 -0400
X-AuditID: 0ac90647-a9f1fba000004aeb-9b-4844d2940102
Message-ID: <4844D290.7000802@hitachi.com>
Date: Tue, 03 Jun 2008 14:11:44 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, sct@redhat.com,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
       tytso@mit.edu, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com> 
    <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com>
In-Reply-To: <4844CB39.6060409@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidehiro Kawai wrote:

> Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io

Sorry, I forgot to remove the subject at the first line...

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

