Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXHPVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXHPVSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXHPVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:18:39 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:43417 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbXHPVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:18:38 -0400
Date: Thu, 16 Aug 2007 14:18:26 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
In-Reply-To: <20070816174510.6o8cray64g8kosos@webmail.df.eu>
Message-ID: <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
 <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
 <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
 <20070816174510.6o8cray64g8kosos@webmail.df.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5 (--)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-2.5/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Clemens Ladisch wrote:

> David Griffith wrote:
> > Checking further, I've never been able to
> > get midi to work with kernels 2.6.18 and later.
>
> Please try "amidi -d -p virtual" and playing a .mid file to this port with
> aplaymidi.

$ aplaymidi -p "virtual" castle2.mid
Invalid port virtual - No such file or directory

amidi reports nothing.

-- 
David Griffith
dgriffi@cs.csubak.edu
