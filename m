Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYG0PIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYG0PIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYG0PIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:08:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33328 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYG0PIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:08:14 -0400
Date: Sun, 27 Jul 2008 09:08:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eran Liberty <liberty@extricom.com>
Cc: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Message-ID: <20080727150813.GE17544@parisc-linux.org>
References: <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org> <4885FBF4.6070306@extricom.com> <20080722165241.GD7337@parisc-linux.org> <48861BAC.1080009@extricom.com> <20080722181132.GE7337@parisc-linux.org> <488778FD.1050206@extricom.com> <488C5570.1050305@extricom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488C5570.1050305@extricom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 02:01:04PM +0300, Eran Liberty wrote:
> Found some time to test my own idea... it seems to work. :)

Is there a reason you haven't tested the tree I posted?

: I've been working in this area recently; here's my current tree:

: http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=pci-read-base

: I've had a quick hack at doing what I want, but I haven't tested it.


-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
