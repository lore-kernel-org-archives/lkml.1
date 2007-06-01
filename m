Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbXFAVg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbXFAVg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760921AbXFAVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:36:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXFAVgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:36:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: 2.6.22-rc3 hibernate(?) disables skge wol
Date: Fri, 1 Jun 2007 23:42:45 +0200
User-Agent: KMail/1.9.5
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, "linux-pm" <linux-pm@lists.osdl.org>
References: <46608E3F.4060201@dgreaves.com>
In-Reply-To: <46608E3F.4060201@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706012342.45657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 June 2007 23:23, David Greaves wrote:
> Not a regression though, it does it in 2.6.21
> 
> If I cause the system to save state to disk then whilst off it no longer
> responds to g-wol.

Can you please try with the hibernation and suspend patch series from

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/

applied?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
