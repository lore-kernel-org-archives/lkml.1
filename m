Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXBWSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXBWSG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbXBWSG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:06:58 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:60093 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbXBWSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:06:58 -0500
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 13:06:57 EST
Date: Fri, 23 Feb 2007 17:40:28 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@jikos.cz>,
       webmaster@kernel.org, linux-kernel@vger.kernel.org,
       "J.H." <warthog9@kernel.org>
Subject: Re: gitweb on kernel.org buggy?
Message-ID: <20070223174028.GC7370@localhost>
References: <Pine.LNX.4.64.0702222219520.10496@twin.jikos.cz> <45DE113D.1020606@zytor.com> <45DED4F6.3000801@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DED4F6.3000801@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=0, required 7, autolearn=disabled)
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would be nice if there was anybody familiar with issues concerning
> high-volume gitweb serving who could contribute.

This bug is fixed (http://lkml.org/lkml/2007/1/5/204), but I guess the
change never made it to kernel.org servers.

Robert

