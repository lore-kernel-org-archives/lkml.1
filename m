Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZHJKnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZHJKnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZHJKnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:43:03 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57431 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZHJKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:43:02 -0400
Date: Mon, 10 Aug 2009 12:43:02 +0200
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
Message-ID: <20090810104302.GD844@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at> <1247338473.9709.107.camel@localhost.localdomain> <20090711195911.GA31549@gamma.logic.tuwien.ac.at> <1247346745.9709.129.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247346745.9709.129.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 11 Jul 2009, Marcel Holtmann wrote:
> > So, /dev/rfkill and the rfkill user mode program is the way to go?
> 
> Yes that is the way to go.

Ok, I have rewritten my rfkill gnome applet with threads and polling
/dev/rfkill. Did work out fine.

I hope the format will not change too often ;-)

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BEALINGS
The unsavoury parts of a moat which a knight has to pour out of his
armour after being the victim of an araglin (q.v.). In medieval
Flanders, soup made from bealins was a very slightly sought-after
delicacy.
			--- Douglas Adams, The Meaning of Liff
