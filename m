Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYIPXgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYIPXgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIPXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:36:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49661 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYIPXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:36:44 -0400
Date: Wed, 17 Sep 2008 00:36:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Julien Blache <jb@jblache.org>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix autoloading of MacBook Pro backlight driver.
Message-ID: <20080916233627.GB18574@srcf.ucam.org>
References: <1221607406.20234.82.camel@macbook.infradead.org> <1221607522.20234.84.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221607522.20234.84.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 04:25:22PM -0700, David Woodhouse wrote:
> Use new MODULE_DEVICE_TABLE(dmi, ...) facility. There's no need for
> every driver to screw it up for themselves, when the alias can be
> generated automatically.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
