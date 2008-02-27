Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYB0Kjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYB0Kjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYB0Kjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:39:47 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48815 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYB0Kjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:39:46 -0500
Date: Wed, 27 Feb 2008 13:38:37 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Miller <davem@davemloft.net>
Cc: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CONNECTOR: make cn_already_initialized static
Message-ID: <20080227103837.GA6237@2ka.mipt.ru>
References: <47C4C954.1090006@cn.fujitsu.com> <20080226.182545.55675767.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226.182545.55675767.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Feb 26, 2008 at 06:25:45PM -0800, David Miller (davem@davemloft.net) wrote:
> > It is used in connector.c only, so make it static.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Applied, thanks.

Thanks for resolving this guys.

-- 
	Evgeniy Polyakov
