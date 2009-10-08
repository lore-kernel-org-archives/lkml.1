Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbZJHXIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbZJHXIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbZJHXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:08:51 -0400
Received: from bu3sch.de ([62.75.166.246]:59922 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbZJHXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:08:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2009-10-08
Date: Fri, 9 Oct 2009 01:08:06 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091008223454.GB2798@tuxdriver.com>
In-Reply-To: <20091008223454.GB2798@tuxdriver.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910090108.08838.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009 00:34:54 John W. Linville wrote:
> Albert Herranz (1):
>       b43: do not stack-allocate pio rx/tx header and tail buffers

Come on, this is _not_ funny anymore. I did _not_ ack this patch, because I do _not_ like it.
I was planning to do a better solution, but I didn't have the time, yet.
Can you _please_ either:
- Wait for my ack before you apply random b43 patches
or
- Remove me from MAINTAINERS

-- 
Greetings, Michael.
