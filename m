Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXHAOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXHAOqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXHAOqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:46:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:7844 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbXHAOqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=r9PDBpXEw+qEk5L8TaWjRvAjcATrJXV+k6GpJuKNeOnGMocernYtEtBrAp5k/ETLoA/UyWrnN/dDouDVXerUWnStJx1ACm1TbTC67HeMqtpFucIHBeGzXox/+joIIXr6E2ufTIe0VOSDNPhVOGu/hcNjAP6KpMmbUOGlnqo7DgY=
Message-ID: <46B09C8E.3010103@googlemail.com>
Date: Wed, 01 Aug 2007 16:45:34 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Tilman Kranz <tilde@tk-sls.de>,
       alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix sound/pci/ca0106/ca_midi.h
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Coding style fix

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/sound/pci/ca0106/ca_midi.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/sound/pci/ca0106/ca_midi.h	2007-08-01 16:38:54.000000000 +0200
@@ -22,9 +22,9 @@
  *
  */
 
-#include<linux/spinlock.h>
-#include<sound/rawmidi.h>
-#include<sound/mpu401.h>
+#include <linux/spinlock.h>
+#include <sound/rawmidi.h>
+#include <sound/mpu401.h>
 
 #define CA_MIDI_MODE_INPUT	MPU401_MODE_INPUT
 #define CA_MIDI_MODE_OUTPUT	MPU401_MODE_OUTPUT
