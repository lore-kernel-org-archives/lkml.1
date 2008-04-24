Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYDXJlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYDXJlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYDXJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:41:21 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:53451 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbYDXJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:41:14 -0400
X-Greylist: delayed 3388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 05:41:14 EDT
Message-ID: <480FE4C8.5070202@keyaccess.nl>
Date: Thu, 24 Apr 2008 03:39:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
References: <20080418204955.342963315@ldl.fc.hp.com> <200804211710.38660.bjorn.helgaas@hp.com> <480E5246.5000804@keyaccess.nl> <200804231708.53572.bjorn.helgaas@hp.com> <480FE1CB.8000202@keyaccess.nl>
In-Reply-To: <480FE1CB.8000202@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-04-08 03:26, Rene Herman wrote:

> Could do a quick test and its cs4236 soundcard works fine with them. 

Oh, this was on v2.6.25 vanilla + 0093cb1199ec551f179562ca9fbd6f64fb750645 
(only post 2.6.25 change to drivers/pnp).

Rene
