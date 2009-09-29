Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZI2SxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZI2SxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZI2SxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:53:08 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:52415 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbZI2SxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:53:04 -0400
X-Greylist: delayed 1207 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2009 14:53:04 EDT
Message-ID: <4AC252DC.9070209@superbug.demon.co.uk>
Date: Tue, 29 Sep 2009 19:33:00 +0100
From: James Courtier-Dutton <James@superbug.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090906)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: no vm86_info: BAD
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a system that sees this message "no vm86_info: BAD"
This happens while doing an "aptitude update", inside a qemu virtual
machine, and causes the http module to segv. This is with kernel 2.6.30
and 2.6.31. Using an older kernel in the virtual machine, cures the problem.

When I move the virtual machine image to another machine, it runs
perfectly OK, so I think that this will be difficult to reproduce elsewhere.

I would like to track this down, can anyone who has knowledge of this
area of the kernel please provide me with some pointers.

Kind Regards

James

