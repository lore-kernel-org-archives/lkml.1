Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZKPGIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZKPGIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZKPGIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:08:35 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:61071 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZKPGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=wVX9IhrBpAorRrAsuo/Gc6XAOutZBVRXua8vo4c81W5U5m0UYhnrsbiBWJFDHvMkna
         oVhUUbBZERTiL9BhD30j9OWrncncDlKiOXGwQtBL0Z+FUFUnftRb21to1OXFAoF6EDWo
         NiT4aTFCd9BGnZkgXDFaoAVu6jqyk7XpF2O4Q=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/5] pcf50633 - error handling & use threaded IRQs - v2
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:08:37 -0800
Message-ID: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Hopefully this is split enough to your liking. It should apply to for-next
branch of mfd tree.

Compile-tested only, still don't have the hardwrae.

-- 
Dmitry
