Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbZLaQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbZLaQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 11:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZLaQRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 11:17:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63349 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZLaQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 11:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=NNYqivGHDJwktnKkZzsTwWEqQI8QAfkzZvE3KZH7/pW9aPLbTkoXREYLnWUy5gpFUs
         zZlMNCrokN9GxwsQtnjuJh5qnWzBk+fqZE6a0jzI3nFJgtlKpYtvqZG4YQcNGaLV6sNk
         6FFpycCa/2I4gptCW/soF3WOMiER8bBHqFxxE=
MIME-Version: 1.0
Date: Thu, 31 Dec 2009 17:17:43 +0100
Message-ID: <2d0a357f0912310817p3b828239qc81994973fca1274@mail.gmail.com>
Subject: [2.6.33{rc2-git1,2}]: hp-wmi again broken
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Cc: Anisse Astier <anisse@astier.eu>, len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not sure why this bug has re-entered from linux-acpi-2.6 to
linux-kernel, but I just wanted to report Anisse has re-send a fix for
hp-wmi [1].
The original bug was reported with appended patch in [2].
>From 2.6.33-rc2 to 2.6.32-git2 hp-wmi is still broken.
Please, fix that cleanly in upstream, now.
Thanks.

Kind Regards,
- Sedat -

[1] ACPI & driver patches for 2.6.33-rc2
http://patchwork.kernel.org/patch/70398/
[2] [2.6.33-rc2] ACPI problems on HP nc6400 notebook
http://patchwork.kernel.org/patch/69745/
