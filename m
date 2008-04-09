Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYDIPOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYDIPOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYDIPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:14:33 -0400
Received: from ns.firmix.at ([62.141.48.66]:1293 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbYDIPOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:14:32 -0400
Subject: Re: coloring stdout && stderr, small kbuild example
From: Bernd Petrovitsch <bernd@firmix.at>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kbuild devel list <linux-kbuild@vger.kernel.org>
In-Reply-To: <E1Jjbol-0002zS-4P@flower>
References: <E1Jjbol-0002zS-4P@flower>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 09 Apr 2008 17:14:00 +0200
Message-Id: <1207754040.6860.7.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2008-04-09 at 17:02 +0200, Oleg Verych wrote:
> Those boring never-ending builds...
> 
> Can some dualCPU power be spent, if building is interactive (i.e. sent to
> terminal), to have them a bit colored?
> 
> My last rant about "colored printk()" led away from kernel developers
> and their solutions. But now, let me share something.

I don't know if it's of any use for you but there is already
*) color-make - http://bre.klaki.net/programs/colormake/ - and
*) color-gcc - http://schlueters.de/colorgcc.html -
out there.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


