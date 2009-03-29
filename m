Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZC2BJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZC2BJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZC2BIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:08:50 -0400
Received: from main.gmane.org ([80.91.229.2]:44985 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZC2BIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:08:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Michael B. Trausch" <mike@trausch.us>
Subject: Re: 2.6.29 network hosed?
Date: Sat, 28 Mar 2009 21:08:30 -0400
Organization: news.gmane.org
Message-ID: <20090328210830.23ddf477@zest.trausch.us>
References: <01fc01c9afe9$5ecb43b0$1c61cb10$@com>
	<1238276579.6669.126.camel@localhost>
	<020901c9afef$47064e90$d512ebb0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 173.15.213.186
X-Newsreader: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 14:50:57 -0700
"Hua Zhong" <hzhong@gmail.com> wrote:

> Thanks. I knew there was some problem with NAPI but I thought it had
> been fixed.
> 
> I'll try the patch on Monday.
> 

I've been using 2.6.29 with the patch from:

  http://patchwork.kernel.org/patch/14465/

And networking has been restored for me.  I haven't tested the other
patch that was mentioned to you, but that can be quickly and easily
found, also on patchwork:

  http://patchwork.kernel.org/patch/14804/

	--- Mike

