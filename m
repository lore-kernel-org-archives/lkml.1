Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYHTWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYHTWmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYHTWm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:42:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYHTWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:42:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [OT] 'git pull' from Linus' tree doesn't work for me any more
Date: Thu, 21 Aug 2008 00:45:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210045.42693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anybody else see something like this after the latest push from Linus:

~/devel/linux-2.6> git pull
fatal: The remote end hung up unexpectedly
Cannot get the repository state from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

?

I see this on two different machines.

Thanks,
Rafael
