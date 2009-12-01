Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZLAMDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZLAMDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZLAMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:03:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41138 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZLAMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:03:32 -0500
Date: Tue, 1 Dec 2009 05:03:37 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: liu weni <qingshenlwy@gmail.com>
Cc: strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091201120337.GV9482@parisc-linux.org>
References: <200911252209432039291@gmail.com> <20091125141505.GH9482@parisc-linux.org> <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com> <20091125195256.GL9482@parisc-linux.org> <b3657a100911302101t59a07518tddfd0a267d4ce64c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3657a100911302101t59a07518tddfd0a267d4ce64c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 01:01:57PM +0800, liu weni wrote:
> Thanks, I will try others way to improve the performance.

Is there a performance problem with iunique?  What benchmark are you
running to show this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
