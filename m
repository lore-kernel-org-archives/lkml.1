Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZJBUeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZJBUeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZJBUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:34:07 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:42874 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbZJBUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:34:06 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Duyck" <alexander.duyck@gmail.com>
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported MTU setting'
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	<COE24pZSBH.A.jd.5MTxKB@chimera>
From: Nix <nix@esperi.org.uk>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Fri, 02 Oct 2009 21:33:34 +0100
In-Reply-To: <COE24pZSBH.A.jd.5MTxKB@chimera> (Rafael J. Wysocki's message of "Thu,  1 Oct 2009 21:56:03 +0200 (CEST)")
Message-ID: <877hvd8rj5.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Oct 2009, Rafael J. Wysocki stated:

> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).

The patch fixes it.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14261
> Subject		: e1000e jumbo frames no longer work: 'Unsupported MTU setting'
> Submitter	: Nix <nix@esperi.org.uk>
> Date		: 2009-09-26 11:16 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=125396433321342&w=4
> Handled-By	: Alexander Duyck <alexander.duyck@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/50277/

(Possibly a stable candidate? It's not in 2.6.31.2-to-be, perhaps the
only patch that isn't. ;) )
