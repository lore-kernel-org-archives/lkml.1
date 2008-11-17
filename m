Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYKQK2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYKQK2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 05:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYKQK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 05:28:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:14130 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYKQK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 05:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AE5u/FIi4Od2xwmPVKhNN9VXq9SlqbXmVgOfEvlPTFEt76OAma9q6Xbuq4mPFAjMle
         gySjliaPGbTL5hNFUQg2HPa+7nUkAT5w5hzRpZwqaYIbJWLeYksrWoaUKcJVJ073kStu
         CRgIIXANs31MGTN3ZkNIHR6PvCV22QAWM8npc=
Date: Mon, 17 Nov 2008 10:28:20 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Buddington <ebuddington@verizon.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, ebuddington@wesleyan.edu,
       Am??rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /init not found in initramfs in 2.6.27.[34]
Message-ID: <20081117102820.GS3800@hack.voiplan.pt>
References: <20081110232313.GA29539@pool-96-236-120-128.spfdma.east.verizon.net> <20081111111922.GA8485@hack.voiplan.pt> <20081112190214.GA26785@pool-96-236-120-128.spfdma.east.verizon.net> <491B281D.5030701@zytor.com> <20081112191914.GC26785@pool-96-236-120-128.spfdma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112191914.GC26785@pool-96-236-120-128.spfdma.east.verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 07:19:14PM +0000, Eric Buddington wrote:
>On Wed, Nov 12, 2008 at 11:01:49AM -0800, H. Peter Anvin wrote:
>> Eric Buddington wrote:
>> > On Tue, Nov 11, 2008 at 11:19:22AM +0000, Am??rico Wang wrote:
>> >> Do you use the same config for 2.6.26.5 and 2.6.27.4 ?
>> >> If not, could you please send the diff between these two configs?
>> > 
>> > I used 'make oldconfig', so they're similar but not identical. Here's the diff:
>> > 
>> 
>> Please use diff -u if you're going to post a diff...
>
>Sorry; I thought the context took up space without adding useful info
>in the context of a .config. Here's the diff -u:

Sorry for my delay.

>
>--- config.ok	2008-11-10 23:09:07.000000000 +0000
>+++ .config	2008-11-09 06:46:26.000000000 +0000

Thanks for this, but I didn't find any important difference in your
configure file.

I will try to look more into this problem.

Thanks!

-- 
"Sometimes the only way to stay sane is to go a little crazy."

