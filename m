Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYJaFx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYJaFx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 01:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYJaFxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 01:53:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:61675 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYJaFxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 01:53:18 -0400
Message-ID: <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
Date: Thu, 30 Oct 2008 22:53:16 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: david@lang.hm
Subject: Re: [GIT PULL] XFS update for 2.6.28
Cc: "Lachlan McIlroy" <lachlan@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>
	 <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:02 PM,  <david@lang.hm> wrote:
> On Fri, 31 Oct 2008, Lachlan McIlroy wrote:
>
>> The following changes since commit
>> 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
>>  Linus Torvalds (1):
>>       Merge branch 'for-linus' of git://neil.brown.name/md
>
> I am a fairly heavy user of XFS and am as eager as anyone to see cleanups
> and improvements, but 102 commits to go into -rc3????
>
> David Lang
>

I'm pretty sure these won't be accepted until 2.6.29's merge window
opens. The merge window for 2.6.28 has closed, and due to the sheer
number of commits, at least -one- is bound to cause a regression.

- Steven
