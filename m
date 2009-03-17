Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZCQXnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZCQXnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZCQXnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:43:11 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:51737 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZCQXnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:43:10 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2009 19:43:10 EDT
Date: Wed, 18 Mar 2009 00:33:31 +0100
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/21] fat: move fs/vfat/* and fs/msdos/* to fs/fat
Message-ID: <20090317233330.GY15474@ojjektum.uhulinux.hu>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp> <4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:57:56PM +0900, OGAWA Hirofumi wrote:
> 
> This just moves those files, but change link order from MSDOS, VFAT to
> VFAT, MSDOS.


Thanks for that! :)

I've asked for it years ago but it was not accepted:
http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1726.html


Have a nice day,

-- 
pozsy
