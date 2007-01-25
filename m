Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXAYA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXAYA4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXAYA4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:56:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60692 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXAYA4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:56:42 -0500
Message-ID: <45B80048.90408@pobox.com>
Date: Wed, 24 Jan 2007 19:56:40 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: set_mode, Fix the FIXME
References: <20070124114707.42370540@localhost.localdomain>
In-Reply-To: <20070124114707.42370540@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> When set_mode() changed ->set_mode didn't adapt. This makes the needed
> changes and removes the relevant FIXME case.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied

Please supply a less ambiguous subject line, per 
Documentation/SubmittingPatches and http://linux.yyz.us/patch-format.html

The subject line is a kernel-wide one-line summary, copied verbatim into 
the changelog, and "set_mode, Fix the FIXME" does not tell the reader 
what portion of the kernel this change applies to.  Or much of anything, 
really.

	Jeff



