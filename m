Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZF2Fv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZF2Fv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZF2FvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:51:17 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44566 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZF2FvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=RYiUv3mauCpYlX5TBEcTSkLLx75aWLDjGj5TmIXDWL+I1h5ISXGh+CqqPefB4zbWZa
         w59jdtaZjokvF29HzHWohpAMS+xQS6BsFHQc3BMCJralO1RWEAo1t/A3uMn7guBnQOHw
         MqJAoiO//rDkYgUfe83yCnGS2+tON5WQEZc/U=
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 11:21:19 +0530
Message-ID: <241b8f7b0906282251x23fead6dobcb24cb639e9fdb0@mail.gmail.com>
Subject: External USB mass storage device no detecting
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I am having WD external mass storage device, which has Mini USB
connector.  They have given the USB type A to mini converter.

I have set CONFIG_USB_STORAGE=y, after building 2.6.18-6.4 version and
booting: I am connecting the device its not getting detected, while
USB stics are getting

detected.

Am I missing any drivers ? Please suggest .

Thanks in advance.
Prabhu
