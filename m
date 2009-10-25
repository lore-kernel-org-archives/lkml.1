Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZJYIKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZJYIKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZJYIKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:10:34 -0400
Received: from www84.your-server.de ([213.133.104.84]:38546 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZJYIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:10:32 -0400
Subject: Re: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
From: Stefani Seibold <stefani@seibold.net>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091024203452.GA10555@parisc-linux.org>
References: <1254248605.8881.1.camel@wall-e>
	 <200909300115.54263.rjw@sisk.pl> <1256393003.9013.4.camel@wall-e>
	 <20091024203452.GA10555@parisc-linux.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 09:10:29 +0100
Message-Id: <1256458229.4026.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 24.10.2009, 14:34 -0600 schrieb Matthew Wilcox:
> On Sat, Oct 24, 2009 at 04:03:23PM +0200, Stefani Seibold wrote:
> > If you need further information or dumps please contact me.
> > 
> > The kernel parameter 'pci=assign-busses' did not fix the problem.
> 
> What does dmesg say when you specify pci=assign-busses?
> 

Okay, i tried it again with 'pci=assign-bussed'. All i get is a

decode_hpp: Could not get hotplug parameters. Use defaults

thats all. The express-card will not be detected.



