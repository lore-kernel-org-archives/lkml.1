Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYHQPcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYHQPcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYHQPce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:32:34 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3690 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYHQPcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:32:33 -0400
Date: Sun, 17 Aug 2008 11:02:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Mirco Tischler <mt-ml@gmx.de>, Leonid Podolny <leonidp.lists@gmail.com>,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       IvDoorn@gmail.com
Subject: Re: CPU load after killing iwlagn with RF kill switch
Message-ID: <20080817150242.GA23926@tuxdriver.com>
References: <48A5EC02.4070303@gmail.com> <20080817035921.4d35ae0e@mtlp.12thdimension> <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:

> There is gap in current rfkill implementation that we didn't close
> yet.  There were also few patches that were not signed by Intel and
> are apparently wrong.

Can you be more specific?  Do you know which patches are wrong (even
if you don't know how to fix them)?

John
-- 
John W. Linville
linville@tuxdriver.com
