Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZKWT3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZKWT3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZKWT3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:29:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZKWT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:29:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Re: PCI: pci_restore_state() is returning 0 when it fails
Date: Mon, 23 Nov 2009 20:29:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: Ben Hutchings <bhutchings@solarflare.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-net-drivers@solarflare.com
References: <4AFD91DD.7000104@linux.vnet.ibm.com> <1258382974.2841.23.camel@achroite.uk.solarflarecom.com> <4B0A8245.6020506@linux.vnet.ibm.com>
In-Reply-To: <4B0A8245.6020506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911232029.58246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009, Breno Leitao wrote:
> Hi Rafael, 
> 
> I didn't hear back after the analysis that there is no regression
> after this patch. Did you have a chance to think about this patch ?

I'm not really sure why you insist that we take it.  Does it solve any problem
that you're observing in practice?  If so, what's your test case.

Rafael
