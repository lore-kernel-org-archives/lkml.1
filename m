Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbXDBO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbXDBO7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXDBO7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:59:20 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40151 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbXDBO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:59:19 -0400
Date: Mon, 2 Apr 2007 10:55:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Blaisorblade <blaisorblade@yahoo.it>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Message-ID: <20070402145530.GB6179@c2.user-mode-linux.org>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4610D937.20002@nagafix.co.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 11:21:43AM +0100, Antoine Martin wrote:
> Just like the network auto-configuration via dhcp, it would allow users 
> to download images+kernel and run them like appliances without 
> understanding anything about X or UML, just click and run.

True, but I don't see that as being revolutionary.  If people are
going to run a VM, presumably they have some purpose in mind, but how
often does that purpose involve having a GUI?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
