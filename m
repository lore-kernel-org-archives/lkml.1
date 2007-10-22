Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXJVDIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXJVDIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXJVDIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:08:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:23515 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXJVDId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jZfcM4KLMzR7lUzWbqfDQSS5Ij/javc8y8Iu9gagXf18fwyuC5WSChM977nCd5QUkZG7WumCSBsv8CEiK6ME3n/Zz939SCwUt0MFR9QH9rldyxz99XVSkVCkeeEBZeNlv8BhOkySaH3o/zGl/3jLx3lDcQOlLjt+KbYyUKou03w=
Message-ID: <82e4877d0710212008m335c5f15s88963aaebf2f6d4a@mail.gmail.com>
Date: Sun, 21 Oct 2007 23:08:32 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, tiwai@suse.de
Subject: 2.6.23 - MacMini - snd-hda-intel stopped working
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ubuntu kernel 2.6.22-10 works fine - I get sound although volume
control doesn't seem to work.

With 2.6.23 (today's git actually) I get this error on loading snd-hda-intel -

[  672.830052] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  673.061586] hda_codec: STAC922x, Apple subsys_id=106b0800
[  673.471059] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[  673.471367] HDA Intel: probe of 0000:00:1b.0 failed with error -16

Any ideas?

Thanks

Parag
