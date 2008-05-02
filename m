Return-Path: <linux-kernel-owner+w=401wt.eu-S1765558AbYEBOik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558AbYEBOik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbYEBOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:38:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41036 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbYEBOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:38:13 -0400
Date: Fri, 2 May 2008 08:38:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Mason <chris.mason@oracle.com>
Cc: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
       Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       John Johansen <jjohansen@suse.de>
Subject: Re: Btrfs v0.14 Released
Message-ID: <20080502143811.GC14976@parisc-linux.org>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805021034.08358.chris.mason@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:34:07AM -0400, Chris Mason wrote:
> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
> the kernel has the patch.  Lets go back to Jeff's suse patch:

Do we really need to support kernels compiled with the apparmour patch
applied but not enabled?  That would be a custom kernel build, and I get
the impression that people Just Don't Do That -- if they want a newer
kernel, they fetch one from kernel.org.  Maybe I'm wrong though.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
