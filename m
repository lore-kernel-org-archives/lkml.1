Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYGDGjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYGDGjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYGDGjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:39:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:13502 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbYGDGjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Oyj3f197PBj/X5a4yV9ysGR+Ljs5rYMYBuV27M/Qv2vhiV+Yay7hxET1tIcFuYpWew
         sTJi2EvV5ER/RUXkeP4ct5K5zgEIPz5WWWl2v/DFFqCX2mV+KAzqeDXfcsCyIVsTkLyy
         t/x5EdPYNYwdFd57nHFvO+nBcGqEQIHNxBP7Q=
Message-ID: <ca0148c30807032339o4182fbadq370f709a28861053@mail.gmail.com>
Date: Fri, 4 Jul 2008 09:39:03 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [patch 1.2.32] WAN: merge driver retina
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is based on linux-next:
http://pcidriver.googlegroups.com/web/retina-patch.txt?gda=Hj6V2UEAAAD9a223ZdyQxc6jQf5toR434ka3fTOuf9SStRjUQ9KuyGG1qiJ7UbTIup-M2XPURDRb8A7WwO6f6JZwMwSZaAwRMXXBcZFbXU7ojtsMSuO4sA
The build error and the warnings reported by David Miller have been fixed.
