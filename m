Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbZJMWnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbZJMWnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbZJMWnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:43:50 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50467 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZJMWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=cR+61nyzPgwzZgq4go/Noz5GPiGZJGDpgODybyhfTeCi2ICGwZett5p14domBquFG0
         FscP/HcSCdOFTm8k3PwQII7vNbBc2dpd+/esLPEHRb8+fqE0sy2GirXj/etpbkHl2Bnm
         3SYdiSZiiHz13U4Jb265+HL4sweemx9S4jKjA=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 13 Oct 2009 15:42:53 -0700
Message-ID: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com>
Subject: Stable compat-wireless 2.6.32-rc4 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Tim Gardner <tim.gardner@canonical.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the kernel moves along so does the automatic stable backports for
the wireless subsystem [1]. We are now on 2.6.32-rc4. Besides getting
the same fixes from rc1..rc4 some backport changes were made as well,
most importantly that of relying on your own kernel's iw_handler.h.
I've tested this release with 2.6.28.

Please report any issues you see.

[1] http://wireless.kernel.org/en/users/Download/stable

PS. If you maintain a distribution and rely on stable compat-wireless
releases please let me know so I can CC you when further updates are
made.

  Luis
