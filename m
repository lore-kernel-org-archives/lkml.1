Return-Path: <linux-kernel-owner+w=401wt.eu-S1030447AbXBTVcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447AbXBTVcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030449AbXBTVcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:32:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447AbXBTVcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:32:47 -0500
Message-ID: <45DB688F.1070209@redhat.com>
Date: Tue, 20 Feb 2007 16:30:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       torvalds@osdl.org, stable@kernel.org
Subject: Re: Linux 2.6.18.7
References: <20070220065946.GA11688@kroah.com>
In-Reply-To: <20070220065946.GA11688@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> We (the -stable team) are announcing the release of the 2.6.18.7 kernel.
> It contains one NFS fix that if you run a NFS server, you might want to
> apply.

Well that's nice.  There's at least one other unfixed CVE
in 2.6.18.6 -- why didn't you fix that?  (The patch has been
queued for two months now.)

