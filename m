Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZESOf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZESOf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZESOfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:35:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37551 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZESOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LLU2+Hn/n8ef0ysTp6hEXP7ipEll6PlgNB6m982l3XMS2kEtYmn6028dOzW11xvjn/
         7MqHc2M+TQt8dah2CP17bALJPKsPbTAANX3hc5ondIsZGmi6GhNdjTrvsOLzlV+sQRwH
         R+h9irEb3bREj9vsGVtGT7P0BUbWeWvFPxMaM=
MIME-Version: 1.0
Date: Tue, 19 May 2009 16:35:16 +0200
Message-ID: <63386a3d0905190735h23ecb2ffi5b9d2e037df8fe2d@mail.gmail.com>
Subject: [PATCH 0/1] MFD: Add U300 AB3100 core support v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog from v2 -> v3:

* Moved setup data to a table lookup.

* Cleaned-up chip variant list.

* Kerneldoc for the ab3100.h header file ab3100 struct.

Linus Walleij
