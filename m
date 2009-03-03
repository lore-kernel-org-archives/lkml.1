Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZCCSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZCCSE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZCCSEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:04:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZCCSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:04:45 -0500
Date: Tue, 3 Mar 2009 19:04:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jason Noble <nobleja@polezero.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: New HID device support
In-Reply-To: <1236103310.12185.1.camel@paradox.pz.local>
Message-ID: <alpine.LNX.2.00.0903031903480.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>  <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz> <1236103310.12185.1.camel@paradox.pz.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Jason Noble wrote:

> > Could you please compile your kernel with CONFIG_HID_DEBUG, modprobe the 
> > 'hid' module with 'debug=2' option, and send me the output that appears in 
> > dmesg when you
> On a monolithic kernel I just pass usbhid.debug=2 at boot correct?

The module accepting the 'debug' option is 'hid', i.e. make this 
'hid.debug=2'.

-- 
Jiri Kosina
SUSE Labs
