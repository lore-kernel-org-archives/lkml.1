Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXCTLUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXCTLUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXCTLUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:20:38 -0400
Received: from server077.de-nserver.de ([62.27.12.245]:42992 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbXCTLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:20:37 -0400
Message-ID: <45FFC36E.1070905@prie.be>
Date: Tue, 20 Mar 2007 12:20:14 +0100
From: Stefan Priebe <stefan@prie.be>
Reply-To: stefan@prie.be
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Olaf Kirch <olaf.kirch@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com>
In-Reply-To: <200703201154.58234.olaf.kirch@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.134.42.121
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Here a some more information:
- sometimes the whole systems crash - sometimes they are still alive
- if they are alive fdisk consumes 99% CPU
- fdisk cannot be killed also not with kill -9
- the same happens with a cat on /dev/sdX
- no problem when trying to access /dev/hdX

Stefan

Olaf Kirch schrieb:
> On Tuesday 20 March 2007 11:33, Stefan Priebe wrote:
>> 1.) I've bootet these systems through NFS and would like to access
>> /dev/sda or /dev/sdb then. For example via fdisk and this does not work.
> 
> What do you mean by "booted through NFS"? Do you mean the machine
> runs with the root file system mounted via NFS? Or does it mean you
> booted, and started the NFS server?
> 
> Olaf

