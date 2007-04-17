Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXDQG7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXDQG7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXDQG7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:59:44 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24990 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXDQG7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hDrAkpOaIrbcphhkefMYLXO9Zy3OIX0r/sZ5FJaKoEr+NujKfKsGfdzu9Six/0KRx87mSowICvFdPDVfTISW8OyYbPwhTIbotK8TtITniC1/Q/EYgTpL/jMOfgOSipErOYOR1yxS6U0BU+lWUrwEF8hNgup4q0yFgaqQl3DtMnI=
Message-ID: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
Date: Tue, 17 Apr 2007 12:29:42 +0530
From: "Madhusudhan c" <cr.madhusudhan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: MMCv4 support (8-bit support missing)
Cc: philipl@overt.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre/philip,

This is regarding the MMCv4 support that came in as part of the MMC
core of 2.6.20 linux kernel version.

The high speed MMC cards can support 4-bit/8-bit transfers. The 8-bit
support seems to be missing from the MMCv4 support implemented by
Philip Langdale .
To support 8-bit transfers the core needs to implement "bus testing
procedure". This requires support for CMD19 and CMD14.

Why is the support for bus testing procedure msiing from the MMCv4 support?

Regards,
Madhu
