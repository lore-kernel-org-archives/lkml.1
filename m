Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbZDIOYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbZDIOYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZDIOYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:24:43 -0400
Received: from tundra.namei.org ([65.99.196.166]:1081 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZDIOYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:24:42 -0400
Date: Fri, 10 Apr 2009 00:24:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: WARNING at linux/security.h:1889 expand_downwards
In-Reply-To: <20090409102416.GA21280@basil.nowhere.org>
Message-ID: <alpine.LRH.2.00.0904100022140.16073@tundra.namei.org>
References: <20090409102416.GA21280@basil.nowhere.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Andi Kleen wrote:

> 
> Haven't seen this one on kerneloops.org, so let's post it.
> 
> I get this warning all the time on one of my test boxes at boot with 2.6.30rc1
> 
> Config is at http://halobates.de/config1
> 
> -Andi
> 
> 
> Freeing unused kernel memory: 600k freed
> ------------[ cut here ]------------
> WARNING: at /home/ak/lsrc/newmce/linux/include/linux/security.h:1889 expand_downwards+0xee/0x179()
> Hardware name: MS-7383

Are you running in a virtual machine?

-- 
James Morris
<jmorris@namei.org>
