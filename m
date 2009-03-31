Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbZCaQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbZCaQhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbZCaQhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:37:34 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46401 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759954AbZCaQhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:37:34 -0400
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 12:37:33 EDT
From: Ayman KHAMOUMA <ayman.khamouma@st.com>
To: <linux-kernel@vger.kernel.org>
Subject: Sysfs with no struc device ?
Date: Tue, 31 Mar 2009 18:19:41 +0200
Message-ID: <000201c9b21c$7f636aa0$663f81a4@par.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcmyHH8b36Dv3lUGSBCiu7KrI0OIKg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I'm trying to write a module which is supposed to write the state of a pin in a sysfs file.
As it is neither a char device nor a block device, or anything else, I suposed taht I don't need any struct device...I mau be mistaking...
So my question is:
How can I create this file in sysfs without any struct device ?


Regards,
 Ayman

