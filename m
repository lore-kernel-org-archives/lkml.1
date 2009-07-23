Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZGWXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZGWXTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZGWXTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:19:51 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:41702 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZGWXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:19:50 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2009 19:19:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=k6d9pPHnQkEsuIJolXtYDwg3VCSyJ9Ou3CUZjG1ruF1LmonIyFVS554nTZjpqrUAOu
         HSEWDOTbhbBM5wphA82h1OIg94CTiqnr6GhPvwCb2b2OqQLQLikpYdHeB87ejL+Op6BO
         KGsN1yiWsOEyxzYBM6p+VmiB/4Nrrk6q67q/4=
Message-ID: <4A68EEA0.2020709@gmail.com>
Date: Thu, 23 Jul 2009 16:13:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: linux-bluetooth@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: No hci0 in 2.6.31-rc4 with the imac 9,1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macbook is showing a device when issuing the command
hciconfig but with the imac 9,1
nothing happens. Is there a patch that has been created for the imac 9,1
(device number added to drviers/bluetooth/*) or is this something I need to
figure out, if so How difficult?

Justin P. Mattock
