Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbXL3UsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbXL3UsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXL3UsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:48:12 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36152 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXL3UsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:48:11 -0500
Message-ID: <47780372.40609@keyaccess.nl>
Date: Sun, 30 Dec 2007 21:45:38 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Richard Harman <richard@richardharman.com>
CC: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <47754735.1050009@richardharman.com> <20071229095242.1300e19c@linux360.ro> <47760ED5.6060207@richardharman.com>
In-Reply-To: <47760ED5.6060207@richardharman.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-12-07 10:09, Richard Harman wrote:

> Anyway, I'm extremely open to getting to the bottom of working around 
> the quirks on this hardware.  If I havn't mentioned it previously, this 
> laptop is an HP dv6408nr, with an amd turion tl-56 cpu and nVidia MCP51 
> chipset.
> 
> What can I do to help?  It has been pulling teeth trying to get to the 
> bottom of this.

This thread-branch appears to be broken on lkml.org so I couldn't look back 
through it but was this what you tried?

http://lkml.org/lkml/2007/12/29/65

Updated patch with Islam's values added at:

http://lkml.org/lkml/2007/12/29/141

You'd plug in your values similarly and test...

Rene.
