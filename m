Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZIKVWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZIKVWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZIKVWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:22:43 -0400
Received: from fifo99.com ([67.223.236.141]:42193 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbZIKVWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:22:42 -0400
Subject: Re: [PATCH 0/5] kernel handling of dynamic logical partitioning
From: Daniel Walker <dwalker@fifo99.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AAABC55.4070207@austin.ibm.com>
References: <4AAABC55.4070207@austin.ibm.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 14:23:18 -0700
Message-Id: <1252704198.28368.31.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:08 -0500, Nathan Fontenot wrote:
>  am cc'ing lkml.
> 
> Patches include in this set:
> 1/5 - DLPAR infrastructure for powerpc/pseries platform.
> 2/5 - Move the of_drconf_cell struct to prom.h
> 3/5 - Export the memory sysdev class
> 4/5 - Memory DLPAR handling
> 5/5 - CPU DLPAR handling
> 

It looks like a couple of your patches have some checkpatch issues..
Could you run these through scripts/checkpatch.pl and clean up any
problems it raises ? Specifically patches 1, 4, and 5 ..

Daniel

