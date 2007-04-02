Return-Path: <linux-kernel-owner+w=401wt.eu-S965975AbXDBVsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbXDBVsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965977AbXDBVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:48:30 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:41601 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbXDBVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:48:30 -0400
Date: Mon, 2 Apr 2007 17:44:34 -0400
From: Jeff Dike <jdike@addtoit.com>
To: roland <devzero@web.de>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Blaisorblade <blaisorblade@yahoo.it>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Message-ID: <20070402214434.GA10205@c2.user-mode-linux.org>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <005601c77567$1ceddb60$eeeea8c0@aldipc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005601c77567$1ceddb60$eeeea8c0@aldipc>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:40:10PM +0200, roland wrote:
> btw - i think besides that packaged uml+rootfs, the same thing could be 
> distributed in other formats, i.e. qemu, vmware, M$ virtual pc (add your 
> favourite v12n solution here)

There are sites (http://uml.nagafix.co.uk/ being the best one I know
of) where, with two downloads, two uncompressions, and one command
line later, you have a booted UML.

The only way I know of to improve on this, aside from inprovements in
the booted distro, is to package the filesystem as a rootfs within the
UML kernel binary.  I've considered this, but haven't done anything
with it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
