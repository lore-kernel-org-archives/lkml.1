Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391Ab0ATRNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0ATRNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810Ab0ATRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:13:20 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:29290 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab0ATRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:13:19 -0500
Date: Wed, 20 Jan 2010 09:12:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: linux-next: Tree for January 20 (kvm warnings)
Message-Id: <20100120091241.3f10428d.randy.dunlap@oracle.com>
In-Reply-To: <20100120181016.6ba3e504.sfr@canb.auug.org.au>
References: <20100120181016.6ba3e504.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B57399A.0116:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 18:10:16 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100119:
> 
> The kvm tree lost its build failure.


on i386/X86_32:

arch/x86/kvm/x86.c:3810: warning: left shift count >= width of type
arch/x86/kvm/x86.c:3812: warning: left shift count >= width of type
arch/x86/kvm/x86.c:3814: warning: left shift count >= width of type

---
~Randy
