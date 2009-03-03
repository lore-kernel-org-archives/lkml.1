Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZCCQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZCCQp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbZCCQpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:45:40 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:22262 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZCCQpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:45:39 -0500
Message-ID: <49AD5F03.2050409@oracle.com>
Date: Tue, 03 Mar 2009 08:46:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 3 (cpufreq)
References: <20090303182633.4ad7831b.sfr@canb.auug.org.au>
In-Reply-To: <20090303182633.4ad7831b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49AD5EA9.002D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090302:
> 
> Undropped trees:
> 	acpi
> 	v4l-dvb


arch/x86/kernel/cpu/cpufreq/longhaul.c:308: error: implicit declaration of function 'acpi_set_register'



I can't find any such function in the linux-next tree.


-- 
~Randy
