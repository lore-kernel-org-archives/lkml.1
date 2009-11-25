Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbZKYD5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbZKYD5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbZKYD5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:57:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:25331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934230AbZKYD5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=xb2Hbw4UyfAn/CRjPEcnEhH4bW6t/UbY5W1clBu45YC+T7sevPad9Imq4A/+OduuJ6
         i85sIdKDPVKUZoG47t4pny5DUoymK/RqTCYGOFTz3N8ug4GmTpbXId7HfxabQx0F8QAf
         hMINPfG+xNrAymQXrZNyjF1B/hO6kSol+N/oI=
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 05:57:51 +0200
X-Google-Sender-Auth: 0e03e94cead1d80c
Message-ID: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>
Subject: touchscreen wirh 2.6.26
From: Alex Custov <alex.custov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have Acer T230H on Debian Lenny with 2.6.26.8 manually complied
kernel. The problem is that this is a multitouch monitor and it seems
that it doesn't work at all (even single touches). All things under
"Drivers => Input device support => Touchscreens" are enabled in
kernel (as modules). Is this type of monitor supported, or I should
upgrade to a newer kernel? Thanks.

Please CC any comments.
