Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZF0V0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZF0V0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 17:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZF0V0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 17:26:32 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:37938 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZF0V0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NdUGBlEwGnSE2RqKJh2Y0er9/JJHc8XVECnPFYARs+4b1U+DaNvAYt+Jtjk17SQv6E
         GK+Ied0qa/tolKGgRzuujD000UJe9pioqUabtdm0OaHjjv9GRqzWJhnPAbkn2tV6UVku
         J3SiNDKDbho5CI0BDYg4hf+l+kriqRFw/RUz8=
MIME-Version: 1.0
Date: Sat, 27 Jun 2009 14:26:34 -0700
Message-ID: <86802c440906271426y2b98d36kfed43487994e0e32@mail.gmail.com>
Subject: warning in compling
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/acpi/sleep.o
drivers/acpi/sleep.c:29: warning: ‘acpi_target_sleep_state’ defined but not used
