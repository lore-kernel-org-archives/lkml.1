Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYAFSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYAFSBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYAFSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:01:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:41436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753879AbYAFSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:01:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CzI4YZxRCcD05yF5VlOEsbsgcjqzQx8JyeOT344
	Rcp0h4m0WNz4XB
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1199612533.4384.54.camel@homer.simson.net>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 19:01:10 +0100
Message-Id: <1199642470.3927.12.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 10:42 +0100, Mike Galbraith wrote:
> FWIW, here's box having same seizure writing to /dev/pktcdvd/sr0.

Ugh, horrid device IO ==> horrid VM AFIKT.  I'll continue rummaging, but
I wonder, am I doing something _so_ stupid as to warrant zero response?

	-Mike

