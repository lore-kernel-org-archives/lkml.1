Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZBFRjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZBFRjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZBFRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:39:35 -0500
Received: from main.gmane.org ([80.91.229.2]:60428 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbZBFRjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:39:35 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: linux 2.6.29-rc3 kernel failure with mptsas
Date: Fri, 06 Feb 2009 12:39:16 -0500
Message-ID: <gmhsk4$4ht$2@ger.gmane.org>
References: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten P.D. Stevens wrote:
> Hi,
> 
> I get a kernel failure with linux 2.6.29-rc3 on my Dell T7400
> Workstation.
> 
> failure message:
> 
> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
> (Tainted: G        W )
> Hardware name: Precision WorkStation T7400  
> Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
> scsi_transport_sas
> Pid: 35, comm: work_on_cpu/0 Tainted: G        W
> 2.6.29-0.66.rc3.fc11.x86_64 #1

> 
> Any ideas about the problem?
> 
See what it does without the tainted kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

