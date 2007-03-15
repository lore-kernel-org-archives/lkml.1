Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXCOBbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXCOBbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXCOBbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:31:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35516 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXCOBbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:31:21 -0400
Date: Thu, 15 Mar 2007 10:31:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <msts@seznam.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm: migrate_pages using
Message-Id: <20070315103157.228c687c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070312185758.GA25820@curandero.idtnet.org>
References: <20070310211631.GA29295@curandero.idtnet.org>
	<20070312163255.73422184.kamezawa.hiroyu@jp.fujitsu.com>
	<20070312185758.GA25820@curandero.idtnet.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 19:57:58 +0100
Michal Hocko <msts@seznam.cz> wrote:

> What do you think about that. Is this way correct?
> 

If you are sure that your "original" pages is never freed while you are
migrating it.....maybe.

-Kame

