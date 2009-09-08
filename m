Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZIHDX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZIHDX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 23:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZIHDXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 23:23:25 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43817 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZIHDXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 23:23:24 -0400
Message-ID: <4AA5CE2C.6070105@gmail.com>
Date: Tue, 08 Sep 2009 05:23:24 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
References: <df9815e70908270145q381ce8acxa3770480431ac526@mail.gmail.com> <df9815e70909071923l22eff525h9706d654f8b41572@mail.gmail.com>
In-Reply-To: <df9815e70909071923l22eff525h9706d654f8b41572@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 08 Sep 2009 05:23:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song a écrit :
> On Thu, Aug 27, 2009 at 4:45 PM, Jike Song<albcamus@gmail.com> wrote:
>> hi, I hit this with vnc. Below is part of dmesg :
> 
> Still producible in 2.6.31-rc9, anybody helps?
> 
> 

How is it triggered ? Is it reproductible ?

Please send a new report to netdev@vger.kernel.org, where some people might help.

Thanks
