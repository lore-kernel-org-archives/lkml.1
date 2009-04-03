Return-Path: <linux-kernel-owner+w=401wt.eu-S935092AbZDCQUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935092AbZDCQUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934125AbZDCQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:06:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35589 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935927AbZDCQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:06:43 -0400
Date: Fri, 3 Apr 2009 17:06:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: qcserial comes up in unhelpful custom mode?
Message-ID: <20090403160639.GA22722@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151232.GA21657@srcf.ucam.org> <20090403155704.GA26189@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403155704.GA26189@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 08:57:04AM -0700, Greg KH wrote:
> On Fri, Apr 03, 2009 at 04:12:32PM +0100, Matthew Garrett wrote:
> > Hmm. What's the USB ID of that one?
> 
> USB_DEVICE(0x05c6, 0x9211);

The driver seems to flag that as the QDL device rather than the modem. 
Are you sure it's working?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
