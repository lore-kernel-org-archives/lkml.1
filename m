Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951Ab0AACqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0AACqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 21:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815Ab0AACqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 21:46:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44538 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751808Ab0AACqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 21:46:06 -0500
Date: Thu, 31 Dec 2009 21:46:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: James Bottomley <James.Bottomley@suse.de>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>,
       Stable Tree <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH] scsi_lib: Bug in completion of bidi commands
In-Reply-To: <4B3C586F.8020200@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0912312144080.16709-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009, Boaz Harrosh wrote:

> James hi.
> 
> What about this BUG. It affects anybody doing bidi commands. The possibilities
> are an sglist leak at best, and a crash at worse.
> 
> I understand this code needs cleanup, but first things first. Lets first fix the
> bug, which should also go to stable. Then the cleanup can go to next merge window.
> 
> BTW: Should I attempt a cleanup on current code, or should I wait for Alan's Patch
> to go in first?

What patch of mine are you referring to?  So far James has rejected all
the patches I have submitted recently.  I'm going to try again in the 
near future...

Alan Stern

