Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYKPPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYKPPjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKPPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:39:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:38290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYKPPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:39:05 -0500
Date: Sun, 16 Nov 2008 07:39:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116073948.02aea58c@infradead.org>
In-Reply-To: <1226846868-9595-1-git-send-email-bwalle@suse.de>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 15:47:45 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> While the original submission of CONFIG_STRICT_DEVMEM mentions that
> the option has been in RHEL and Fedora for 4 years without problems,
> that's only a half of the story. The truth is that at least RHEL
> has /dev/crash exactly to circumvent that /dev/mem restriction. Don't
> tell me that this is better than having that sysctl entry. ;-)

I assume /dev/crash is read only


but your series still makes absolutely no sense to me...
really. Nak.

You either want this at compile time or you don't want it at all.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
