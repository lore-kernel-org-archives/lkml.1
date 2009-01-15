Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZAOMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZAOMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZAOMEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:04:09 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39676 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZAOMEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:04:08 -0500
Subject: Re: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200901141316.27584.david-b@pacbell.net>
References: <200901141316.27584.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 12:04:03 +0000
Message-Id: <1232021043.4934.365.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:16 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor cleanup to the regulator set_mode sysfs support:
> switch to sysfs_streq() in set_mode(), which is also
> a code shrink.  Use the same strings that get_mode()
> uses, shrinking data too.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Applied.

Thanks

Liam

