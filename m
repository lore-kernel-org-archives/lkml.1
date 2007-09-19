Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXISIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXISIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXISIeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:34:44 -0400
Received: from hera.cwi.nl ([192.16.191.8]:63101 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbXISIen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:34:43 -0400
Date: Wed, 19 Sep 2007 10:36:41 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Satyam Sharma <satyam@infradead.org>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>, Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iso9660 vs udf
Message-ID: <20070919083640.GC11444@mette>
References: <20070915214926.GA31416@mette> <20070918144734.GB13304@atrey.karlin.mff.cuni.cz> <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in> <20070919004657.GB11444@mette> <alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709190736140.28653@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 08:05:32AM +0530, Satyam Sharma wrote:

> I was actually asking for the logs explaining why you thought
> the _kernel_ incorrectly "announced" it as an UDF filesystem.

No, the CDROM announces itself as an UDF filesystem.

> Hmm ... those "CD-RTOS", "CD-BRIDGE" and "CDUDF File System - Adaptec Inc"
> bits are not dmesg output, are they?

No, hexdump of the CDROM.

Andries

