Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXA1Jt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXA1Jt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 04:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXA1Jt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 04:49:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:21110 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbXA1Jt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 04:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JQnjcXoBna7XFPxGVDCuOZFvyXvtnA7qrEE+TWQhConcPNu4nClmEhmJDWq7+dh32AvpsEARQgKbcozQSAFQsG1dg7ypcovn+Q5RlymrDk6W3yoAFfpHjQCSS7A9xUcu9Jq8awfd2lv4i5NBU0JqlbcyuoD7Jp1oiqH5m3MzaQ0=
Message-ID: <5157576d0701280149o5cbb72eelb2979680a174df74@mail.gmail.com>
Date: Sun, 28 Jan 2007 12:49:25 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-rc6 regression: kernel output redirected to console
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I booted last time with 2.6.20(as I remember -rc4),
I don't see this issue:
all kernel message instead of just
go to syslog-ng and then into /var/log/messages
also go to console.
