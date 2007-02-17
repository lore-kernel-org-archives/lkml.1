Return-Path: <linux-kernel-owner+w=401wt.eu-S965305AbXBQQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305AbXBQQKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965304AbXBQQKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:10:41 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58172 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965305AbXBQQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:10:40 -0500
Date: Sat, 17 Feb 2007 11:10:40 -0500
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflows in the tty flip buffer in 2.6.17
Message-ID: <20070217161040.GU7584@csclub.uwaterloo.ca>
References: <45D6F52B.000003.10185@webmail19.yandex.ru> <20070217151729.GS7584@csclub.uwaterloo.ca> <45D724A3.000002.25611@mfront7.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D724A3.000002.25611@mfront7.yandex.ru>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:52:03PM +0300, Mockern wrote:
> Thanx for your respond. 
> 
> Could you please inform me what patches exactly you have grabbed?

If you see the thread "Re: Strange problem with tty layer", which I just
posted a final update too, it has the list of linux-2.6 git commits that
I applied to 2.6.16 in order (some of them are probably in 2.6.17
already, while others might not be).

--
Len Sorensen
