Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZA2Daz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZA2Daz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZA2Dar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:30:47 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61391 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbZA2Daq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:30:46 -0500
Message-ID: <498122B5.90605@oracle.com>
Date: Wed, 28 Jan 2009 19:29:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-28-17-42 uploaded (ata/ahci.c)
References: <200901290142.n0T1gq02009439@imap1.linux-foundation.org>
In-Reply-To: <200901290142.n0T1gq02009439@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.498122BA.023D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-28-17-42 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29-rc3:

This function is in ahci.c 2 times:

drivers/ata/ahci.c:2578: error: redefinition of 'ahci_broken_system_poweroff'
drivers/ata/ahci.c:2552: error: previous definition of 'ahci_broken_system_poweroff' was here

-- 
~Randy
