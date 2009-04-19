Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZDSUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZDSUF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZDSUFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:05:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38751 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZDSUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:05:10 -0400
Date: Sun, 19 Apr 2009 21:03:30 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] PM/Suspend: Introduce two new platform callbacks to
	avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
Message-ID: <20090419200330.GA16002@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl> <20090418144132.GC7148@flint.arm.linux.org.uk> <200904182047.48009.rjw@sisk.pl> <alpine.LFD.2.00.0904191357280.12867@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904191357280.12867@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 01:57:44PM -0400, Len Brown wrote:
> Acked-by: Len Brown <len.brown@intel.com>

Thanks.  Since there's no objections yet, can we get this merged?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
