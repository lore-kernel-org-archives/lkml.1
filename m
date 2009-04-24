Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZDXJ2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZDXJ2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZDXJ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:28:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZDXJ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=KGZmbb1li7C0SNmLne7i5dNosLUp6+royCvRipC3O2Xo38hPqTdAEehj4EWFgVmQjd
         Nw3EwF672/I9BwuJmkA7MiSTK4r0dzsQLAfgbrWTKVjCzkQ2ZcAxUCf8ThM4DFr21b/J
         73DVvLqvCibHWpBuG1psTBCOE0+yghPjqMRbY=
MIME-Version: 1.0
Date: Fri, 24 Apr 2009 11:28:28 +0200
X-Google-Sender-Auth: ca727e1a10d2605e
Message-ID: <63a49ef40904240228g6a28ba8dsf63d2e0bdc6b57d9@mail.gmail.com>
Subject: RFC about Comedi on a patch that remove a lot fo code
From: Alessio Igor Bogani <abogani@texware.it>
To: Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Comedi-ml <comedi_list@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Comedi developers,

Sorry for my bad english.

I would be happy to receive your considerations about that patch:

http://marc.info/?l=linux-next&m=123792129500760&w=2

I know that some users use Comedi on dual kernel approach systems.
Obviously I don't have any against this but i think that Linux git
tree isn't the right place to support those software (RTAI, Xenomai,
RTLinux and others). Those projects already released patches against
Linux source code so it very easy for them add also patch for Comedi
drivers in the same tarball.

At the already listed 8 reasons  in that email I want added a ninth one:
9) Give more chance for interested developers to fix it against RT_PREEMPT
http://marc.info/?l=linux-rt-users&m=124049407712792&w=2

Thanks!

Ciao,
Alessio
