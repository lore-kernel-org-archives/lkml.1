Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYLSUDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYLSUDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYLSUDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:03:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:1087 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYLSUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hKu/6zi9OPTyCUjKHWq7fKJhRRGWzCOqAjh+oSbdr6XDnro1nOq87nQz9Nqc3ma1MW
         W06zKUyzHN6UKCLwDKJCRNbNS6qe1cO0aAlIoY/ud56Wfz4FnZ7AzlnMzmdmx4gh/qvp
         gq3BrQDDEYpR3PRvjuv5QgTBEWfaThFTNe5cc=
Message-ID: <3f9a31f40812191203v22401bb5j7a8809a5125de3ce@mail.gmail.com>
Date: Sat, 20 Dec 2008 01:33:44 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, "David Woodhouse" <dwmw2@infradead.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org
Subject: Firmware patches for DVB
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

These DVB's firmware patches are floating in linux-next from long time :

1. firmware: convert av7110 driver to request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=402669d75012c5f12c27b799145c10db79715f51
2. Remove fdump tool for av7110 firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=43b0a12fa4ac50f6875ea5a238f9e9e26f3fe390

Should I need to resend these patches to merge main-stream.

Thank you,

Jaswinder Singh.
