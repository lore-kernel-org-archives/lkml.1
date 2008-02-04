Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYBDCM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYBDCM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYBDCMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:12:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53106 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYBDCMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:12:49 -0500
Date: Sun, 3 Feb 2008 17:59:38 -0800
From: Greg KH <greg@kroah.com>
To: Patrick Ringl <patrick_@freenet.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-storage@vger.kernel.org
Subject: Re: wrong cylinders of kingston usb pendrive [intel 82801DB]
Message-ID: <20080204015937.GA16989@kroah.com>
References: <47A6615D.9090201@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A6615D.9090201@freenet.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 01:50:37AM +0100, Patrick Ringl wrote:
> Hello,
>
> I am suffering from the following (usb-related?) problem:
>
> I have several different mashines - all x86 architecture - just lets call 
> them mashineA, mashineB and mashineC.

Is the kernel the same on all of these machines?

thanks,

greg k-h
