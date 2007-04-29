Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXD2Q3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXD2Q3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbXD2Q3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:29:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42946 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbXD2Q3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:29:18 -0400
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
From: David Woodhouse <dwmw2@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <20070429094135.GA10948@suse.de>
References: <20070406154628.GG12005@jukie.net>
	 <m1zm4rd676.fsf@ebiederm.dsl.xmission.com> <20070429094135.GA10948@suse.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 17:28:59 +0100
Message-Id: <1177864139.3085.37.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 11:41 +0200, Bernhard Walle wrote:
> I also heard that the 100-$-Laptop should now be able to use Windows.
> As it's using LinuxBIOS, this could also be interesting. However,
> maybe Microsoft simply modifies a special Windows for this, or they
> integrate a ClosedSource part in that LinuxBIOS, I don't know ... :-(

You heard wrong. Microsoft have a few early test units and are trying to
get Windows to boot on it. I believe their plan involves replacing
LinuxBIOS with a 'normal' PC BIOS.

-- 
dwmw2

