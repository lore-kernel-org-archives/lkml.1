Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbZLEXM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbZLEXM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932743AbZLEXMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:12:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55686 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZLEXMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:12:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5823"; a="29166178"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
In-Reply-To: <20091205221100.GA32522@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 05 Dec 2009 15:12:17 -0800
Message-Id: <1260054737.23633.35.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 23:11 +0100, Pavel Machek wrote:
> Hi!
> 
> Where is the tree with HTC Dream support? I thought it was 
> 
> http://git.kernel.org/?p=linux/kernel/git/dwalker/linux-msm.git;a=summary
> 
> but it does not seem to contain basic dream support (board file and
> serial console) and I thought that was going to linus for 2.6.33...?

It's here

git://codeaurora.org/quic/kernel/dwalker/linux-msm.git

In the "testing" branch .. 

or

https://www.codeaurora.org/gitweb/quic/kernel/?p=dwalker/linux-msm.git;a=shortlog;h=refs/heads/testing

It's been in Linux-next for maybe two weeks .. I've been trying to
decide if I should submit it for 2.6.33. I'm going to be adding boat
loads of additional msm code and doing a fairly large merge for
2.6.34 .. So your code would get better testing if we wait for that.

However, If you really want it in 2.6.33 I'll try to accommodate you.

Daniel

