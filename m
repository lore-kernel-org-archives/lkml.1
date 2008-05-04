Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYEDOTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYEDOTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYEDOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:19:15 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:35842 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYEDOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:19:14 -0400
Message-ID: <481DC60A.7090307@keyaccess.nl>
Date: Sun, 04 May 2008 16:19:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl> <200805011447.38234.bjorn.helgaas@hp.com> <481DC4E2.7060803@keyaccess.nl>
In-Reply-To: <481DC4E2.7060803@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-05-08 16:14, Rene Herman wrote:

> In trying to come up with problems I'm only finding a difference in an 
> added failure mode with respect to the static array if we run out of 
> memory at a bad time and this is quite unserious.

I mean, this would be an added mode when just releasing and rbuilding teh 
list as opposed to teh reusing, it's not a diffeerence with respect to the 
.index setup.

So, going to completely slash struct pnp_resource again? :) Would improve 
things...

Rene.
