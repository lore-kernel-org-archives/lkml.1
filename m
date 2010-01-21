Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051Ab0AUU2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0AUU2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821Ab0AUU2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:28:04 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:45988 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0AUU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:28:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jO9afXLAkFnjz++AEx87/C8EL9RoCiNmleIK1xYIe+daARvV+O/X3Z5/pfR1/rGWTS
         +jtuUVRPLvntiF6f3n/YoxoqhMXtNPzkgipP6xTv53v3PQCHVUJg0fDNKoOq6ejTeDo0
         hXcaGb4JX2UkTC7ql7rBOFtrGcM+9vBZO0Ovg=
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 15:27:58 -0500
Message-ID: <bcba51a1001211227y1cbe9020k5079367f05dd17a1@mail.gmail.com>
Subject: Current status of UML development?
From: Dimitry Golubovsky <golubovsky@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am learning/experimenting with UML internals, and am curious what is
the current status of its development? Has UML become stable enough so
it does not need any improvement (at least for i386), or has its
development just ceased in favor of other virtualization techniques?

Also I am trying to find recent papers covering modern UML's principles of
functioning (especially the skas0 mode when /proc/mm is not
available), but most of the papers that Google returns date back to
2001 - 2003, and often state that "each UML process gets its own host
process" that does not seem correct these days.

Thanks for any hints.

-- 
Dimitry Golubovsky

Anywhere on the Web
