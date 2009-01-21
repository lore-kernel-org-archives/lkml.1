Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZAUOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZAUOun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZAUOue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:50:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60175 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZAUOue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:50:34 -0500
Subject: Re: [PATCH -next] regulator: fix header file missing kernel-doc
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090120162905.62e2228c.randy.dunlap@oracle.com>
References: <20090120162905.62e2228c.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 14:50:30 +0000
Message-Id: <1232549430.16911.342.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 16:29 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix regulator/driver.h missing kernel-doc:
> 
> Warning(linux-next-20090120//include/linux/regulator/driver.h:108): No description found for parameter 'get_status'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Liam Girdwood <lrg@slimlogic.co.uk>
> cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/regulator/driver.h |    1 +
>  1 file changed, 1 insertion(+)
> 

Applied.

Thanks

Liam

