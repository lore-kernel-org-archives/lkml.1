Return-Path: <linux-kernel-owner+w=401wt.eu-S1762563AbYEFBOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762563AbYEFBOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYEFBOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:14:10 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55157 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbYEFBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:14:09 -0400
Message-ID: <481FB110.9070504@keyaccess.nl>
Date: Tue, 06 May 2008 03:14:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PNP: cleanup pnp_fixup_device()
References: <481FAF79.2030407@keyaccess.nl>
In-Reply-To: <481FAF79.2030407@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 03:08, Rene Herman wrote:

> In response to off-list AD181x thread, small cleanup to quirk handling.
> 
> Patch 3/3 does the actual work. Mind if I feed this stuff through you? And,
> mind this, period? Not wed to it or anything...

This by the way is still against your v5. I see there are changes in current 
mainline again. If you need me to regenerate against mainline, please say.

Rene.
