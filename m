Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbZLFNvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbZLFNvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 08:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZLFNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 08:51:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZLFNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:51:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5823"; a="29198591"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
In-Reply-To: <20091206074120.GA1615@ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>  <20091206074120.GA1615@ucw.cz>
Content-Type: text/plain
Date: Sun, 06 Dec 2009 05:51:27 -0800
Message-Id: <1260107487.23633.55.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 08:41 +0100, Pavel Machek wrote:
> Hi!
> 
> > > Where is the tree with HTC Dream support? I thought it was 
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/dwalker/linux-msm.git;a=summary
> > > 
> > > but it does not seem to contain basic dream support (board file and
> > > serial console) and I thought that was going to linus for 2.6.33...?
> > 
> > It's here
> > 
> > git://codeaurora.org/quic/kernel/dwalker/linux-msm.git
> ...
> > It's been in Linux-next for maybe two weeks .. I've been trying to
> > decide if I should submit it for 2.6.33. I'm going to be adding boat
> > loads of additional msm code and doing a fairly large merge for
> > 2.6.34 .. So your code would get better testing if we wait for that.
> > 
> > However, If you really want it in 2.6.33 I'll try to accommodate you.
> 
> It would be good to get it in 2.6.33, so that we can build on it, and
> so that you are marked as official maintainer etc. I do not think that
> code would benefit from any additional delays...

Ok. Fine with me, unless someone else has a specific objection .

Daniel

