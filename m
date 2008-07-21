Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYGUJBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYGUJBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYGUJA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:00:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55296 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbYGUJA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:00:58 -0400
Message-ID: <48844FE4.1040708@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 16:59:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com> <20080721084443.GD20011@lenovo>
In-Reply-To: <20080721084443.GD20011@lenovo>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> well, as only Al find new version more or less correct we could
> update yours.
>  

Sorry, I don't quite catch what you mean for my poor English. :(

Do you expect me to update and resend my version? or do you mean don't
drop the patch in -mm but you will resend a patch based against it?


