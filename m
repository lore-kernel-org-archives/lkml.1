Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZDFNTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZDFNTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZDFNTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:19:30 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:35788 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbZDFNT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:19:29 -0400
Subject: Re: [PATCH] regulator: fix header file missing kernel-doc
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20090403213130.9995f03b.randy.dunlap@oracle.com>
References: <20090403213130.9995f03b.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 14:19:00 +0100
Message-Id: <1239023941.12172.194.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 21:31 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add regulator header file missing kernel-doc:
> 
> Warning(include/linux/regulator/driver.h:117): No description found for parameter 'set_mode'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc:	Liam Girdwood <lrg@slimlogic.co.uk>
> cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/regulator/driver.h |    1 +
>  1 file changed, 1 insertion(+)
> 

Applied.

Thanks

Liam

