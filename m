Return-Path: <linux-kernel-owner+w=401wt.eu-S1760314AbYFDVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314AbYFDVPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYFDVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:15:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:25005 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYFDVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:x-mailer;
        b=WNX3gXMue+X11C/AnySA3oZFE7cq+yiFx+umzFRDTyXx3wSymGOYh9HS4NS5PMjfaf
         IRkDEjX6v+R1s0fM4tyMgLkgLITBWbP9hdK1jtVnn0tuEb7YVkKmS6V3t5MNjHzkBGYq
         885WcmEPAmAf9HO4D7x+m0yNE/nz5Tmo3Ma1o=
Message-Id: <47E5F47D-5290-46C0-8CF7-E898E72C4FCD@gmail.com>
From: Marco Cassinerio <marco.cassinerio@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: PCI burst transfer mode
Date: Wed, 4 Jun 2008 23:15:39 +0200
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
i'm writing a PCI Express driver. Currently it supports single address  
single data transfer mode.
I'm wondering if there is a way to get burst transfer mode working,  
because I've Googled enough to get no satisfying results.

Thanks
Cpu86
