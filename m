Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbXLKSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbXLKSeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLKSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:34:10 -0500
Received: from gherkin.frus.com ([192.158.254.49]:52404 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbXLKSeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:34:09 -0500
Subject: Re: [patch] alpha: strncpy/strncat fixes
In-Reply-To: <20071211200720.A23822@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Dec 11, 2007 08:07:20 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Tue, 11 Dec 2007 12:34:02 -0600 (CST)
CC: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Bob Tracy <rct@frus.com>,
       Michael Cree <mcree@orcon.net.nz>, Kay Sievers <kay.sievers@vrfy.org>,
       mingo@elte.hu, rjw@sisk.pl, greg@kroah.com,
       linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071211183403.2DC67DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> (...)
> (http://bugzilla.kernel.org/show_bug.cgi?id=9457).
> 
> [ev6-]stxncpy.S: (...)
> strncpy.S: (...)
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

ACK.  2.6.24-rc3 working fine for me with this patch applied.
Nice work!

--Bob Tracy
rct@frus.com
