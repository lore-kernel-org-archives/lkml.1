Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYKLTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYKLTCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYKLTCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:02:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYKLTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:02:01 -0500
Message-ID: <491B281D.5030701@zytor.com>
Date: Wed, 12 Nov 2008 11:01:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ebuddington@wesleyan.edu
CC: Am??rico Wang <xiyou.wangcong@gmail.com>,
       Eric Buddington <ebuddington@verizon.net>, linux-kernel@vger.kernel.org
Subject: Re: /init not found in initramfs in 2.6.27.[34]
References: <20081110232313.GA29539@pool-96-236-120-128.spfdma.east.verizon.net> <20081111111922.GA8485@hack.voiplan.pt> <20081112190214.GA26785@pool-96-236-120-128.spfdma.east.verizon.net>
In-Reply-To: <20081112190214.GA26785@pool-96-236-120-128.spfdma.east.verizon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Buddington wrote:
> On Tue, Nov 11, 2008 at 11:19:22AM +0000, Am??rico Wang wrote:
>> Do you use the same config for 2.6.26.5 and 2.6.27.4 ?
>> If not, could you please send the diff between these two configs?
> 
> I used 'make oldconfig', so they're similar but not identical. Here's the diff:
> 

Please use diff -u if you're going to post a diff...

	-hpa
