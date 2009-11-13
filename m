Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZKMQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZKMQYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbZKMQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:24:26 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45276 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072AbZKMQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:24:26 -0500
Date: Fri, 13 Nov 2009 16:24:31 +0000
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: lsorense@csclub.uwaterloo.ca, hpa@zytor.com, technoboy85@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113162431.GV15157@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <200911,<20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <SNT125-W3FF05F92BC6F07010B0F9C3A80@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SNT125-W3FF05F92BC6F07010B0F9C3A80@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 09:55:12PM -0800, Yuhong Bao wrote:
> Well, do you know the history of the Geode line? It originated in the Cyrix MediaGX, then that was sold to NSC and renamed to Geode, then that was sold to AMD later.

That is the history of the Geode GX line yes.  The Geode LX is an AMD
design, and the Geode NX is an athlon with a lower voltage.  Hence the
LX probably isn't anything like the original GX.  It certainly has none
of the bugs or performance issues of the GX.

-- 
Len Sorensen
