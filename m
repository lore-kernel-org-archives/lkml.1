Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXFMR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXFMR1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXFMR1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:27:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:63784 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbXFMR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R5/dwJTOYzLKgAhW2uLDxsW07FKAfAGnM2sBRYat8KvGkbpzdG2lO6hvOUqvTKx+Ya71B2OLTLu/4SHNLoWmmRJxdF3H40wgPZQIBVanxhRoZHDTXtDPDP3N74Q1ZLysYYw9eZ7E+oz1AhSrXXQ5I89+99XM9J/OPCpC0WcTWn8=
Message-ID: <9c21eeae0706131027i21d97e16k7aedf54134c727b8@mail.gmail.com>
Date: Wed, 13 Jun 2007 10:27:34 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: kvm-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kvm + IOMMU
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if anyone has done any sort of virtualization testing
with kvm using IOMMU to improve performance of I/O and what sort of
results they've had... I currently don't have a box with IOMMU (at
least I don't think so, since its an i386 box) but will be getting
some amd64 boxes which, hopefully will have that capability.

I was also wondering if kvm can take advantage of IOMMU does it need
to be run a different way? or is it supposed to 'just work' if the
kernel is built with IOMMU?

I keep seeing IOMMU patches fly by on the lkml however those are from
the intel guys and the new boxes we are getting are amd... have the
amd IOMMU support gotten into the kernel yet?

Not sure if this is the best place to ask these questions, so any help
to point me in the right direction on who to talk to would also be
helpful.

Thanks,
- David Brown
