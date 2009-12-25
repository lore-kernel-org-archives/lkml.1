Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZLYKKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZLYKKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZLYKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:10:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57230 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZLYKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=K4CfgZg2R8it4VVWxZGz9mq4nZieUU5UxURJqjly+3HIGu1dvVxvePfzOWIv34MEta
         heABFp0ryrPI7ClyGgrspEcuAf6U+hLejSn733WPzNloCCo6rCkOimwovB3RTVAFTgII
         v4aJ5wLfveFsQOlwdOf0j2fLAMzqQXL85StHU=
MIME-Version: 1.0
Date: Fri, 25 Dec 2009 11:10:42 +0100
Message-ID: <8db1092f0912250210w20261f75wbae6bf93696b6f04@mail.gmail.com>
Subject: [2.6.33-rc2] [ACPI] [WMI?] boot hang
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known kernel: 2.6.33-rc1
Affected kernel: 2.6.33-rc2

Kernel stops booting on this message:
http://unixy.pl/maciek/download/kernel/2.6.33-rc2/gumis/zdjecie033.jpg

(sorry for bad picture, already I'm away from home and better camera).

Config, lspci:
http://unixy.pl/maciek/download/kernel/2.6.33-rc2/gumis/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
