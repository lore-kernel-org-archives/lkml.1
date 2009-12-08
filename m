Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZLHOWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZLHOWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZLHOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:22:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62501 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZLHOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U/2SzLQZMG7Sx9d6y/rvX8aAKeDfMh0aX3jDUMmOJSADOYmHyWjCe+a3++2JsgQks+
         ahNPgDGI9mKZKH3Gv7/7mnG7L3tC/Yjg4WBbaC7G26mgY3pqVbzfE/+RBm46FbBiw8pX
         1VzeplJaYn5ZoSJQqXwzgxAJbdQDGxeHIIwug=
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Date: Tue,  8 Dec 2009 15:21:33 +0100
Message-Id: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@sphairon.com>

The following two trivial patches add support for this device to
zd1211rw (ejecting the virtual USB drive) and ar9170usb (that drives
the WLAN chip inside).

Best regards,

	Stefan Seyfried
