Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXHLFqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXHLFqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXHLFqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:46:13 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46472 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756139AbXHLFqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:46:12 -0400
Message-ID: <386897566.13887@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 12 Aug 2007 13:46:06 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812054606.GA8992@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <386838491.27058@ustc.edu.cn> <661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com> <20070811100015.2417788e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811100015.2417788e.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 10:00:15AM -0700, Andrew Morton wrote:
> On Sat, 11 Aug 2007 20:00:12 +0530 "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:
> 
> > On 8/11/07, Fengguang Wu <fengguang.wu@gmail.com> wrote:
> 
> hm, both people who replied to this removed Fengguang from cc.  Disagreement
> between headers and MUAs, perhaps?

Hehe, my email setup is somehow complicated. I'd better not to intermix
fengguang.wu@gmail.com and wfg@mail.ustc.edu.cn in one single mail :)

