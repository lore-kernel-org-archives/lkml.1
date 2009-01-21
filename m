Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZAUHQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZAUHQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 02:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZAUHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 02:15:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbZAUHPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 02:15:44 -0500
Subject: Re: [PATCH -next] driver-core: fix kernel-doc parameter name
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>
In-Reply-To: <20090120162913.fffe3305.randy.dunlap@oracle.com>
References: <20090120162913.fffe3305.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 07:15:26 +0000
Message-Id: <1232522126.5013.1.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 16:29 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix function parameter name in kernel-doc:
> 
> Warning(linux-next-20090120//drivers/base/core.c:1289): No description found for parameter 'dev'
> Warning(linux-next-20090120//drivers/base/core.c:1289): Excess function parameter 'root' description in 'root_device_unregister'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Mark McLoughlin <markmc@redhat.com>

Acked-by: Mark McLoughlin <markmc@redhat.com>

Thanks,
Mark.

