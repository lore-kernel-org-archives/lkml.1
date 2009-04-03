Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbZDCQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbZDCQqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZDCQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:45:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43992 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763591AbZDCQp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:45:56 -0400
Date: Fri, 3 Apr 2009 17:45:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403164551.GA23689@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403151237.GA25994@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 08:12:37AM -0700, Greg KH wrote:

> Hm, look at the linux-usb list, someone has posted a shell script that
> gets the hardware to work properly already.

I've reimplemented this as C code with udev hooks. I'll post it once 
I've checked Alexander is fine with the licensing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
