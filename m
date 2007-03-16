Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXCPQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXCPQeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965512AbXCPQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:34:07 -0400
Received: from ns.firmix.at ([62.141.48.66]:46725 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965499AbXCPQeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:34:03 -0400
Subject: Re: [RFC] A need for "yesno"-function? (and "cleanup" of kernel.h)
	(was: Re: [KJ] [RFC] A need for a "yesno"-function?)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45FAB6C5.8050302@student.ltu.se>
References: <45F95351.60308@student.ltu.se>
	 <39e6f6c70703152036m778ea054gf32723d0eda2be68@mail.gmail.com>
	 <45FAB6C5.8050302@student.ltu.se>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Fri, 16 Mar 2007 17:33:52 +0100
Message-Id: <1174062833.26648.56.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.419 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.419 required=5
X-Spam-Score: -2.419 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 16:24 +0100, Richard Knutsson wrote:
[...]
> more readable). The big problem is, where to put it? Seems wrong to put 
> in <linux/string.h> since it appear to be a replica of userspace's 
> <string.h> (otherwise, why put mem*-functions in there?).

memcpy(3) and memcmp(3) are also there in user-space.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

