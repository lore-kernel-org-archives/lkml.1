Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZEDRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZEDRG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZEDRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:06:47 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3626 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZEDRGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:06:46 -0400
Date: Mon, 4 May 2009 19:06:37 +0200
From: Olivier Galibert <galibert@pobox.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090504170636.GA56325@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090504124129.GL7141@linux.vnet.ibm.com> <20090504124433.GW8822@parisc-linux.org> <20090504130638.GN7141@linux.vnet.ibm.com> <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k54wal0j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 09:30:20AM -0700, Eric W. Biederman wrote:
> When all of the pieces are public how can having secret veiled reasons
> make sense?

Because knowingly violating a patent triples the damages, among other
things.

There's a persistent rumor that a valid microsoft US software patent
exists that covers the standard method of handling long file names on
FAT filesystems.  It seems that such a patent is used by microsoft in
litigations, the latest being against tomtom.  I think all of these
litigations have been settled, but I can easily be wrong.

I have no idea whether such a patent actually exists, and even knowing
the reference (I don't) I am not competent to judge what it covers or
whether it would actually hold up in court.

But knowingly violating a patent is consider way worse in US courts
than simple independant recreation.  So I guess the knowingly part is
what the "you need a local lawyer" crowd tries to avoid.

  OG.

