Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0BSGGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:06:55 -0500
Received: from lo.gmane.org ([80.91.229.12]:55479 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0BSGGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:06:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
Date: Fri, 19 Feb 2010 06:06:26 +0000 (UTC)
Message-ID: <loom.20100219T063902-409@post.gmane.org>
References: <20100218095200.63509b8c@bike.lwn.net> <m37hqamlau.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.176.251.1 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2) Gecko/20100218 Ubuntu/10.04 (lucid) Firefox/3.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Should we lose the others too, then?
> 
> pullcord:cjb~/git/linux-2.6 % du -sh **/ChangeLog
> 8.0K	arch/arm/nwfpe/ChangeLog
> 32K	drivers/char/ChangeLog
> 20K	drivers/parport/ChangeLog
> 16K	fs/befs/ChangeLog
> 100K	fs/ntfs/ChangeLog
>

There are several others scattered around

Archives of changelogs
16K	Documentation/ide/ChangeLog.ide-cd.1994-2004
4.0K	Documentation/ide/ChangeLog.ide-floppy.1996-2002
16K	Documentation/ide/ChangeLog.ide-tape.1995-2002
64K	Documentation/scsi/ChangeLog.1992-1997

Last updated in 1997!
14K     sound/oss/CHANGELOG

Updated periodically by Nick Cheng <nick.cheng@areca.com.tw>
8.0K	Documentation/scsi/ChangeLog.arcmsr

Updated periodically by various LSI employees
24K	Documentation/scsi/ChangeLog.megaraid
16K	Documentation/scsi/ChangeLog.megaraid_sas

Added with driver in 2005, never updated
92K	Documentation/scsi/ChangeLog.lpfc

Last updated 2002
8.0K	Documentation/scsi/ChangeLog.ips
24K	Documentation/scsi/ChangeLog.ncr53c8xx
32K	Documentation/scsi/ChangeLog.sym53c8xx
8.0K	Documentation/scsi/ChangeLog.sym53c8xx_2

But of course, there are changelogs in all sorts of other files as well, along
with severely outdated TODOs (such as Documentation/kernel-parameters.txt circa
2002)

