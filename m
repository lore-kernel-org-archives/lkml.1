Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0CEQGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:06:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34116
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab0CEQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:06:07 -0500
Date: Fri, 05 Mar 2010 08:06:26 -0800 (PST)
Message-Id: <20100305.080626.09630724.davem@davemloft.net>
To: daniel@fooishbar.org
Cc: skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100305160434.GE2505@tempa>
References: <20100305154009.GC2505@tempa>
	<20100305.074835.159078083.davem@davemloft.net>
	<20100305160434.GE2505@tempa>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stone <daniel@fooishbar.org>
Date: Fri, 5 Mar 2010 18:04:34 +0200

> So you're saying that there's no way to develop any reasonable body of
> code for the Linux kernel without committing to keeping your ABI
> absolutely rock-solid stable for eternity, no exceptions, ever? Cool,
> that worked really well for Xlib.

read() still works the same way it did 30 years ago last time I
checked.
