Return-Path: <linux-kernel-owner+w=401wt.eu-S932888AbXJQLOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbXJQLOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXJQLOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:14:01 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:47440 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbXJQLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:14:00 -0400
Date: Wed, 17 Oct 2007 12:13:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: veerasena reddy <veerasena_b@yahoo.co.in>
cc: "linux-kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Linux-2.6.18.8 compilation errors with GCC-4.2.1 and binutils-2.17
 on MIPS
In-Reply-To: <304090.76321.qm@web8411.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64N.0710171207580.28993@blysk.ds.pg.gda.pl>
References: <304090.76321.qm@web8411.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, veerasena reddy wrote:

> mips-linux-ld: final link failed: Bad value

 It looks like some kind of a problem with a relocation somewhere.  The 
error is cryptic and of little help, I know, but I reckon diagnostics has 
been a little bit improved in this area of the linker since 2.17, so it 
would help if you upgraded binutils to 2.18.

  Maciej
