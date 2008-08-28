Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYH1H5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYH1H5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYH1H5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:57:36 -0400
Received: from main.gmane.org ([80.91.229.2]:57129 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYH1H5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:57:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: libata, Sound on same IRQ : flaky sound
Date: Thu, 28 Aug 2008 07:57:22 +0000 (UTC)
Message-ID: <loom.20080828T075203-963@post.gmane.org>
References: <48B5F877.8030506@garzik.org> <Pine.LNX.4.44.0808280320470.31973-100000@hubble.stokkie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.157.229.32 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert M. Stockmann <stock <at> stokkie.net> writes:


> 
> the BIOS supports raid0, but the sata disks are running standalone
> as /dev/sda /dev/sdb etc.
> 
> installing a recent kernel is not that easy, as the required
> upgrade of udev will break the initscripts and a lot of installed
> services and even the functionality of the KDE desktop. Installing
> a recent distro is not desirable as they resemble me only
> of a Open Source Vista distro, where it takes months to clean
> up the unwanted garbage and bloat inside. Its preposterous that
> a upgrade to a recent kernel mandates the installation of a recent
> distro. I run Mandrake 10.1 with kernel 2.6.15 and some applications
> upgraded like firefox, mplayer and k3b etc.
> 
> Robert


If you don't want bloat AND you want a recent kernel AND lots to fiddle around
and figure out for yourself, install PLD Linux :) No, seriously. Last time I
tried, a usable graphic environment (GNOME that is, dunno about KDE) fitted in
300-500 MiB ON DISK. (without graphical env. fitted in 150MB ON DISK). Try that.

el es

