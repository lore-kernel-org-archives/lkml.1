Return-Path: <linux-kernel-owner+w=401wt.eu-S1751168AbXBNID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbXBNID3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXBNID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:03:29 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:19114 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXBNID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:03:28 -0500
In-Reply-To: <20070214012732.GA9023@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH debugfs: implement symbolic links
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF3AFCA38F.FEB02E68-ONC1257282.002B8139-C1257282.002C41B5@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Wed, 14 Feb 2007 09:03:24 +0100
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 14/02/2007 09:03:26,
	Serialize complete at 14/02/2007 09:03:26
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote on 14.02.2007 02:27:32:
> On Tue, Feb 13, 2007 at 12:13:54PM +0100, Peter Oberparleiter wrote:
> > This function can be useful
> > for people moving functionality from /proc to debugfs (e.g. the
> > gcov-kernel patch).
> 
> You aren't really creating debugfs symlinks from /sys/kernel/debug/ to
> the /proc directory are you?  That's pretty insane...

Interesting idea :) But I was thinking more along the lines of replacing
existing /proc files and symlinks with files and links in debugfs.

> Otherwise I have no objection to this, I'll add it to my queue...

Great, thanks!


Regards,
  Peter Oberparleiter
