Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbYJXWJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbYJXWJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbYJXWJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:09:14 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:10193 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYJXWJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FXTJleTinzr5L18zWRbuElU6WdlsJ1l8BAtk2wWroIMNNpu6H1zUnJ0uO7dL4cEQAT
         KmmhJFbhdBip2DCt8e2MOk+wTNzsBGyvs2HhLyi9Lc9/xaImHWJacYUNq0o4RjJlTBgY
         tAUkapk9wS0lcXhTPzXVhoyjnLiwqwFGUKgwg=
Message-ID: <b637ec0b0810241509j43a6bfc9q506dc16a612e7f06@mail.gmail.com>
Date: Sat, 25 Oct 2008 00:09:12 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ACPI warning in 2.6.28-rc1
Cc: "ACPI mailing list" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
As the subject says:

ACPI Warning (nspredef-0858): \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Return
Package type mismatch at index 11 - found Buffer, expected String
[20080926]

No functional problems so far.
