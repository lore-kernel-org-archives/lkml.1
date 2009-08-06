Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZHFRKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZHFRKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZHFRKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:10:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57769 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZHFRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:10:24 -0400
Date: Thu, 6 Aug 2009 19:10:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Dillow <dave@thedillows.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090806171021.GF22124@basil.fritz.box>
References: <20090805171513.GA10443@kroah.com> <20090805192037.19c54c4d@lxorguk.ukuu.org.uk> <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org> <1249575658.19886.8.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249575658.19886.8.camel@lap75545.ornl.gov>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you use mount by label or UUID, you still need udev (or other tools)

I don't use that on my boxes.

> in the initrd to find the right disk, correct? And for distros that want
> to support that, does this really reduce the amount of code in the
> initrd?

There are more users than just distros.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
