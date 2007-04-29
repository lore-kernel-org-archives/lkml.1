Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbXD2Jli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbXD2Jli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXD2Jlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:41:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:49470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbXD2Jlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:41:36 -0400
Date: Sun, 29 Apr 2007 11:41:35 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
Message-ID: <20070429094135.GA10948@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
References: <20070406154628.GG12005@jukie.net> <m1zm4rd676.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm4rd676.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com> [2007-04-29 08:51]:
> 
> It may also be worth investigating if it is possible to bypass
> the part of windows that uses BIOS calls.  I really don't have
> a clue how a modern windows systems boots.

I think ReactOS has a bootlader that can also boot Windows, or at
least they are close to booting the Windows kernel. That bootloader
could be then used for booting Windows without BIOS calls.

I also heard that the 100-$-Laptop should now be able to use Windows.
As it's using LinuxBIOS, this could also be interesting. However,
maybe Microsoft simply modifies a special Windows for this, or they
integrate a ClosedSource part in that LinuxBIOS, I don't know ... :-(


Thanks,
   Bernhard
