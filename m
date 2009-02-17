Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZBQQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZBQQbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZBQQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:31:41 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40133 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZBQQbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VL8PG6/E5dG20dglfvcrqDS0pRfXot2DVGl9BRvpO7+4MwToQP0qJZW8mCo8N/teSf
         A6pv8fj/2oNazTuyr4CkHGKZXsSa6b2DmLqchnP18y1nAClU9FZY06xNhg8wBAEdI6rQ
         ZJlq9DpINENTeWx+TPx+2/uDmTmLLBELs7P/U=
MIME-Version: 1.0
Date: Tue, 17 Feb 2009 16:31:38 +0000
Message-ID: <6278d2220902170831n3801a935x578b5dff64d00c62@mail.gmail.com>
Subject: [2.6.29-rc5 ACPI] truncated dsobject list...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.29-rc5 on an Intel S5000PAL server (BIOS
S5000.86B.10.60.0091.100920081631), we see ACPI object list truncation
[1]. Does it make sense to increase the default element allocation?

Many thanks,
  Daniel

--- [1]

ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (6) larger than
NumElements count (4), truncated
[20081204]
-- 
Daniel J Blueman
