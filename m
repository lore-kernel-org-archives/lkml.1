Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZBXBcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZBXBcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBXBcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:32:24 -0500
Received: from kroah.org ([198.145.64.141]:54140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783AbZBXBcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:32:24 -0500
Date: Mon, 23 Feb 2009 17:29:59 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org Natalie Protasevich" <protasnb@gmail.com>,
       Stable Kernel Team <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, kpalberg@gmail.com
Subject: Re: [stable] 2.6.29-rc6: Reported regressions 2.6.27 -> 2.6.28
Message-ID: <20090224012959.GA25443@kroah.com>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:00:52PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12559
> Subject		: Huawei E169 doesn't work as mass storage anymore
> Submitter	: kpalberg <kpalberg@gmail.com>
> Date		: 2009-01-28 02:34 (27 days old)

I'm pretty sure this has been tracked down to a buggy firmware in the
device itself, and the company (Huawei) is working on updating it to
solve the issue.

This is backed up by the fact that Huawei submitted the patch that is
said to have broken this device :)

thanks,

greg k-h
