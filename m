Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbZJXUeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbZJXUeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZJXUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:34:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34347 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZJXUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:34:49 -0400
Date: Sat, 24 Oct 2009 14:34:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
Message-ID: <20091024203452.GA10555@parisc-linux.org>
References: <1254248605.8881.1.camel@wall-e> <200909300115.54263.rjw@sisk.pl> <1256393003.9013.4.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256393003.9013.4.camel@wall-e>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 04:03:23PM +0200, Stefani Seibold wrote:
> If you need further information or dumps please contact me.
> 
> The kernel parameter 'pci=assign-busses' did not fix the problem.

What does dmesg say when you specify pci=assign-busses?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
