Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYJ3Aeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYJ3Aeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYJ3Aen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:34:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21261 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYJ3Aem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:34:42 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=O6zQN7YRlnZNtOCQghIA:9 a=1cnTDQ6TPThIdqxiiJjm3nzFOAMA:4 a=0txMyaFBVUcA:10
Message-ID: <4909011F.1050102@shaw.ca>
Date: Wed, 29 Oct 2008 18:34:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: upstream regression (IO-APIC?)
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no>
In-Reply-To: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> The current Linus tree as of commit e946217e4fdaa67681bbabfa8e6b18641921f750
> is broken for me.  I get either the following panic (see log from qemu below)
> or lost IRQs on ATA init...  Is this a known issue?
> 
> PS The tree that I used before and was supposedly good (sorry, I'm too tired
> to verify it now) had commit 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 at head.

What's the bootup dmesg from a working kernel?
