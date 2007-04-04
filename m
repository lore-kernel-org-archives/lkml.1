Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbXDDGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbXDDGgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXDDGgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:36:25 -0400
Received: from eazy.amigager.de ([213.239.192.238]:37867 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbXDDGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:36:24 -0400
Date: Wed, 4 Apr 2007 08:36:20 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070404063620.GA5465@dose.home.local>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local> <460D51AA.2080307@redhat.com> <20070331094631.GA24220@thinkpad.home.local> <461117BB.5040705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461117BB.5040705@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:48:27 -0400, Chuck Ebbert wrote:

[...]

> Well, it works for me on 32-bit as well, right up to 100% full.
> No problems at all...

Maybe it depends on the kernel. I patched 2.6.20 with the patches
above and got the described behaviour.

Regards,
Tino
