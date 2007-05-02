Return-Path: <linux-kernel-owner+w=401wt.eu-S2993169AbXEBWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993169AbXEBWCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993178AbXEBWCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:02:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993169AbXEBWCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:02:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -utrace] Move utrace into task_struct
In-Reply-To: Alexey Dobriyan's message of  Wednesday, 2 May 2007 15:32:52 +0400 <20070502113252.GA8017@localhost.sw.ru>
X-Windows: a mistake carried out to perfection.
Message-Id: <20070502220203.D73D21801A3@magilla.sf.frob.com>
Date: Wed,  2 May 2007 15:02:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That's just a workaround for an actual bug that I need to fix.
You wouldn't really want to do it that way.


Thanks,
Roland
