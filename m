Return-Path: <linux-kernel-owner+w=401wt.eu-S967574AbXILMKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967574AbXILMKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765469AbXILMKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:10:45 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:45039 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765273AbXILMKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:10:44 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Greg KH <greg@kroah.com>
Subject: Re: hci_sock.c build failure
Date: Wed, 12 Sep 2007 15:10:02 +0300
User-Agent: KMail/1.9.7
Cc: Andre Haupt <andre@finow14.de>, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain> <20070912120407.GB13003@kroah.com> <20070912120726.GA13170@kroah.com>
In-Reply-To: <20070912120726.GA13170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709121510.03653.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

12 Eyl 2007 Çar tarihinde, Greg KH şunları yazmıştı: 
> No, this is worse, i386 doesn't have a compat_timeval structure defined,
> nor does any other 32 bit platform.
> 
> Marcel, I think you need to use a different structure, care to fix this
> up?

I sent a patch for this problem about ~4 hours ago :), see "[PATCH] Fix hci_sock build with CONFIG_COMPAT=n"

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
