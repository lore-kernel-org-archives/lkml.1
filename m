Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXKEP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXKEP7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXKEP7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:59:14 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58125 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbXKEP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:59:14 -0500
Date: Mon, 5 Nov 2007 18:59:14 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] W1: fix memset size error
Message-ID: <20071105155913.GB30901@2ka.mipt.ru>
References: <472E8054.6000006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472E8054.6000006@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 10:30:44AM +0800, Li Zefan (lizf@cn.fujitsu.com) wrote:
> The size arguments passing to memset is wrong.
> 
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

Thanks a lot, patch is obviously correct.

ACK.

-- 
	Evgeniy Polyakov
