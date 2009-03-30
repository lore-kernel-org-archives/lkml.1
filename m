Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZC3XYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZC3XYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZC3XYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:24:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:13527 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3XYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LDSQ4iXxo328RRhve++PK9aeOvLcxOq4yvi5H5ANWShRWMGd+/KrFEVJ7wc5ttOmA+
         bDciD1TtyjMKKi1dGstiy3vfY2wBKRATc53pQqJ1+FjC1UUnCtyXrDawyndx3UlT5TCd
         5JXk9atvg6bPlU+TWRB2YrgQq03nwbTVVmSi0=
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 01:24:08 +0200
Message-ID: <15d0b9b20903301624j45040f38tdd1ce5400bbaa247@mail.gmail.com>
Subject: Additional USB identifier for rt2870 driver
From: Daniele Napolitano <dnax88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch for Sitecom WL-315:

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
--- rt2870.h 2009-02-07 01:27:09.000000000 +0100
+++ rt2870.h~ 2009-02-07 01:26:58.000000000 +0100
@@ -95,6 +95,7 @@
  {USB_DEVICE(0x0DF6,0x002B)}, /* Sitecom */ \
  {USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */ \
  {USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */ \
+ {USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */ \
  {USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */ \
  {USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */ \
  {USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */

-- 
Daniele "DnaX" Napolitano
https://launchpad.net/~dnax88
