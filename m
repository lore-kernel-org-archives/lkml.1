Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667Ab0ASKc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0ASKc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 05:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746Ab0ASKc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 05:32:56 -0500
Received: from eazy.amigager.de ([213.239.192.238]:32850 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab0ASKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:32:55 -0500
Date: Tue, 19 Jan 2010 11:32:48 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with
 2.6.33-rc4-git2
Message-ID: <20100119103248.GA8527@mac.home>
Mail-Followup-To: Stephen Hemminger <shemminger@vyatta.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100115091053.GA5477@mac.home>
 <201001180136.45823.rjw@sisk.pl>
 <20100118083757.GA2619@mac.home>
 <201001182234.55113.rjw@sisk.pl>
 <20100118144340.100c9544@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118144340.100c9544@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 14:43:40 -0800, Stephen Hemminger wrote:
> On Mon, 18 Jan 2010 22:34:55 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

[...]

> > Perhaps we clear the WoL setting somewhere we shouldn't, but the
> > "disable PCI register writes" bit prevents this from actually happening?
> > 
> > Rafael
> 
> How about getting a register dump of pci config space with
> good/bad version?

At which point should the dump be placed? Somewhere as near to the              
actual suspend as possible?                                                     
                                                                                
Regards,                                                                        
Tino                                                                            
