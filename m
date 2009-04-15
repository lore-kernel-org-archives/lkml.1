Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZDOWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZDOWb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZDOWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:31:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZDOWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:31:46 -0400
Date: Wed, 15 Apr 2009 15:26:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: norsk5@yahoo.com, michael@ellerman.id.au,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 0/3] Add CPC925 Memory Controller EDAC drivers
Message-Id: <20090415152635.2e1e260a.akpm@linux-foundation.org>
In-Reply-To: <1239602716-18352-1-git-send-email-qingtao.cao@windriver.com>
References: <1239602716-18352-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 14:05:13 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> 
> Hi Doug and Michael,
> 
> This is the latest v2 patches, the 1/3 of CPC925 MC EDAC driver remains
> the same as before, the 2/3 has been pushed to Andrew already, and the 
> 3/3 has integrated Michael's suggestions to add a fixup routine for the 
> memory controller on Maple that has incorrect number of cells, and create
> related platform_device for CPC925 on Motorola ATCA-6101 target by far.
> 
> All patches have been tested, please give me your further concerns or 
> suggestions, thanks!

For some reason I didn't have 2/3 anywhere.

I'll plan to merge all these into 2.6.31 unless someone shouts at me.


