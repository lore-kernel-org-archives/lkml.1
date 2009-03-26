Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZCZPXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZCZPXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZCZPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:23:16 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57099 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZCZPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:23:15 -0400
Message-ID: <49CB9DC1.2060807@oracle.com>
Date: Thu, 26 Mar 2009 08:22:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next as a plain diff ?
References: <20090326100555.GA21835@elf.ucw.cz>
In-Reply-To: <20090326100555.GA21835@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49CB9DDB.00F7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> Is there linux-next available somewhere as a plain diff? I'd like to
> look at tomoyo changes... unfortunately that does not seem exactly
> easy. I thought that maybe -mm could help, but... latest -mm listed on
> kernel.org is for 2.6.28-rc2-mm1....

linux-next diffs are available (.gz or .bz2) in this dir:
  http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/

-- 
~Randy
