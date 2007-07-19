Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbXGSUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbXGSUpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbXGSUov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:44:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXGSUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:44:51 -0400
Subject: Paravirt ops 64 bit git tree
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, rusty@rustycorp.com.au, jeremy@goop.org
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 19 Jul 2007 17:45:30 -0300
Message-Id: <1184877930.16311.14.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks,

After a long while, I'm giving the pvops64 tree the attention it
deserves again. It's been a long time, so it diverged a lot from the
rest of the work being done, and it is quite unusable as it is nowadays.
But at least now, it'll get it's own git tree, which you can clone at
git://git.et.redhat.com/kernel-pvops-64.git

Chris Wright and I decided that it might be better to rewrite at least
large chunks of it, so the code that is there, outdated as it is, is
more a reference than anything else. I'll be starting it mostly from
scratch, but it'll live in the same place.

Hope you enjoy!


