Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0CJSeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:34:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:64617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0CJSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dFqBZFW+I9j5/T+wl0/avRzASFoQeyusMRVNJ+LZo6TWGB60q7Ud2CDesxKwav+1kG
         HYhWqToPT6SUnWf1fnNQaJJYEEVuJsijZUSntdVgxFedX9xNJSWI2gshDRub29AAHTcl
         Gfzne1OguGeMHihgrERKPAycBdb52As6LHjKc=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 20:34:12 +0200
Message-ID: <c1fb08351003101034h17957f4ele0a6cbec085fc434@mail.gmail.com>
Subject: Linux 2.6.24 Through Linux 2.6.33 Benchmarks
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.24 Through Linux 2.6.33 Benchmarks

http://www.phoronix.com/scan.php?page=article&item=linux_2624_2633&num=1

quote:
"This test system was using the EXT3 file-system and we found its
TPC-B database performance to improve by many times between the Linux
2.6.29 and 2.6.30 kernel releases. In fact, the Linux 2.6.30 kernel
was 770% faster than its predecessor was and it remained that way with
the Linux 2.6.31 kernel and then regressed only slightly with the
Linux 2.6.32 kernel. With the new Linux 2.6.33 kernel, however, the
PostgreSQL performance atop the EXT3 file-system has fallen off a
cliff. Not only has the PostgreSQL performance lost its gains made
during the 2.6.30 development cycle, but also with Linux 2.6.33, it is
actually much slower than it was in any of the pre-2.6.30 releases."

http://www.phoronix.com/data/img/results/linux_2624_2633/2.png
