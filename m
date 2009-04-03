Return-Path: <linux-kernel-owner+w=401wt.eu-S1764975AbZDCN5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764975AbZDCN5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZDCN5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:57:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46363 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZDCN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:57:25 -0400
Date: Fri, 3 Apr 2009 14:57:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403135719.GD19774@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403025654.GA20146@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:56:54PM -0700, Greg KH wrote:

> But, I have heard reports of people dual-booting with other operating
> systems and then successfully using the device under Linux with the
> qcserial driver, so that is one solution for some users.

So it's a driver that's useless without a closed source firmware loader, 
either in the form of a Linux userspace application that can't be 
distributed or in the form of Windows? I thought we'd decided that 
drivers weren't going to be merged in that case (poulsbow, the original 
3945 driver)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
