Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZGZQJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZGZQJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 12:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZGZQJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 12:09:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55642 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZGZQJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 12:09:32 -0400
Message-ID: <4A6C80C3.8090007@redhat.com>
Date: Sun, 26 Jul 2009 19:13:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: g3vbv@blueyonder.co.uk
CC: linux-kernel@vger.kernel.org, Sid Boyce <sboyce@blueyonder.co.uk>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: OpenSolaris boot failure with KVM and VirtualBox
References: <4A5ED714.7010304@blueyonder.co.uk>
In-Reply-To: <4A5ED714.7010304@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 10:30 AM, Sid Boyce wrote:
> I first tried using kernel 2.6.31-rc1 on openSUSE 11.2 Milestone1 on a
> 4P box. All other VM's, Windows and Linux work, currently running
> openSUSE 11.2 Milestone 3 with 2.6.31-rc3. Verified the .iso is good.
> Error message
> =============
> Booting 'OpenSolaris 2009.06'
> kernel$ /platform/i86pc/kernel/$ISADIR/unix
> loading '/platform/i86pc/kernel/$ISADIR/unix' ...
> cpu: 'AuthenticAMD' family 16 model 4 step 2 ...
> [BIOS accepted mixed-mode target setting!]
>    [Multiboot-kernel, loadaddr=0xbffe38, text-and-data=0x1b1ff0, bss=0x0,
> entry=0xc00000]
> 'platform/i86pc/kernel/amd64/unix' is loaded
> module$ /boot/$ISADIR/x86.microroot
> loading '/boot/$ISADIR/x86.microroot' ...
> Error 15: File not found
> Press any key to continue ...
> Regards
> Sid.
>    

Please copy kvm@vger.kernel.org on kvm issues.

Is this a regression from previous kernel versions?  What userspace are 
you using?

-- 
error compiling committee.c: too many arguments to function

