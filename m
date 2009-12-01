Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZLAQD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZLAQD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZLAQD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:03:56 -0500
Received: from mga05.intel.com ([192.55.52.89]:53705 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753617AbZLAQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:03:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,321,1257148800"; 
   d="scan'208";a="751769236"
Date: Tue, 1 Dec 2009 15:44:12 +0000
From: Alan Cox <alan@linux.intel.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Joe Peterson <joe@skyrush.com>,
       Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch] tty: move a definition out of switch block
Message-ID: <20091201154412.4002a0d8@linux.intel.com>
In-Reply-To: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 02:54:44 -0500
Amerigo Wang <amwang@redhat.com> wrote:

> 
> It's not good to leave a definition between 'switch'
> and its first label. Move it out of the switch block.

"Not good". On what basis is it not good to put variables local to
their scope ?

Alan
