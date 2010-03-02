Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0CBXmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:42:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35855 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab0CBXmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:42:20 -0500
Date: Tue, 2 Mar 2010 23:42:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 56/62] msi-laptop: Support standard ec 66/62 command on
	MSI notebook and nebook
Message-ID: <20100302234219.GC13739@srcf.ucam.org>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-56-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267572541-410-56-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 03:28:55PM -0800, Greg Kroah-Hartman wrote:
> From: Lee, Chun-Yi <jlee@novell.com>
> 
> Suppport standard ec 66/62 command on MSI notebook and nebook. MSI
> netbook and notebook already support 66/62 command, so, add new
> get_state function, and put the old model to non-standard model, but
> driver still support those old model.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
ACKed-by: Matthew Garrett <mjg@redhat.com>

Greg, could you send x86 platform drivers patches via me from now on? 
There's some stuff in this patchset that isn't sane.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
