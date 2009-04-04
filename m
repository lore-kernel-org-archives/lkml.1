Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZDDSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZDDSiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZDDShs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:37:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53185 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZDDShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:37:47 -0400
Date: Sat, 4 Apr 2009 19:37:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexander Shumakovitch <shurik@gwu.edu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: qcserial/gobi firmware loader
Message-ID: <20090404183739.GA7085@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org> <20090404152731.GA5080@srcf.ucam.org> <20090404181422.GA27714@gwu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090404181422.GA27714@gwu.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 02:14:22PM -0400, Alexander Shumakovitch wrote:
> Hi,
> 
> Messages magic4 magic5 contain the length of the second firmware file that has
> to be implanted using the same procedure as in magic2 and magic3 (without
> subtracting 8). The CRC checksum has to be updated afterwards.

Good catch. I've uploaded a fixed version.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
