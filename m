Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZK3SJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZK3SJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZK3SJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:09:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60515 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZK3SJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vevHMSk3lSSBT0ldZ4ZExsypvYINELCBLpGRd+6VX3EMJYcfXrdhOgmDi/W/KC/SM7
         H1K+Z3aKrchzbY+boLIRIa2dEOFc5Us5yHLLhWpROLTvwIG/AtZ8T8Y2JVpnLQtJe8uz
         D6Q+IAQ2hZiJ4dix0qzWKov1irFnpm9UZZhmY=
MIME-Version: 1.0
Date: Mon, 30 Nov 2009 21:09:48 +0300
Message-ID: <53cc795f0911301009y786f5624v7c9f81736e0f18d8@mail.gmail.com>
Subject: netconsole trouble 2.6.31.6
From: sbs <gexlie@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello

I was using dynamic netconsole for some servers with kernel 2.6.31
It worked fine and great.

Yesterday I updated kernel to 2.6.31.6 and have found that there is no
netconsole directory under /sys/kernel/config/ anymore.

is that a bug or was anything changed between 2.6.31 and  2.6.31.6
kernel about netconsole that made this directory gone away?



my dynamic netconsole  kernel options:
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y

CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_RTC_INTF_SYSFS=y
CONFIG_SYSFS=y

CONFIG_CONFIGFS_FS=y
