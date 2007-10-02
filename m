Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbXJBXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbXJBXeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXJBXeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:34:36 -0400
Received: from ozlabs.org ([203.10.76.45]:50970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXJBXeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:34:36 -0400
Subject: [PATCH 0/5] Boot protocol changes
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       lguest <lguest@ozlabs.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:34:12 +1000
Message-Id: <1191368052.17826.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	Jeremy had some boot changes for bzImages, but buried in there was an
update to the boot protocol to support Xen and lguest (and kvm-lite).
I've copied those fairly simple patches, and if HPA is happy I'd like to
push them for 2.6.24 (after correcting for the Great Arch Merge of
course).

Thanks,
Rusty.

