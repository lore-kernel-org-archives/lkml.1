Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYEOHxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYEOHxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYEOHxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:53:05 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47146 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYEOHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:53:04 -0400
Message-ID: <482BEC42.9060605@keyaccess.nl>
Date: Thu, 15 May 2008 09:54:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [patch 6/8] PNP: replace pnp_resource_table with dynamically
 allocated resources
References: <20080505223630.682082986@ldl.fc.hp.com> <20080505224000.013817328@ldl.fc.hp.com> <20080513194241.d11664df.akpm@linux-foundation.org> <200805141718.35158.bjorn.helgaas@hp.com>
In-Reply-To: <200805141718.35158.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-05-08 01:18, Bjorn Helgaas wrote:

> Thanks for the report.  I think I've fixed the problem.

I saw it was PnPBIOS by the way. PnPBIOS appears to be obsolete these 
days; do you have machines to test it on yourself? I do (plenty), so 
although I'm not being fast with testing anyway, would you want me to 
switch those from PnPACPI to PnPBIOS?

Rene.
