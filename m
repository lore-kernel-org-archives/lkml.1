Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbXCNX1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbXCNX1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCNX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:27:33 -0400
Received: from ns.suse.de ([195.135.220.2]:39830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbXCNX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:27:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: vgoyal@in.ibm.com
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
Date: Thu, 15 Mar 2007 00:10:05 +0100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, hpa@zytor.com, magnus.damm@gmail.com,
       lwang@redhat.com, dzickus@redhat.com, pavel@suse.cz, rjw@sisk.pl
References: <20070307065703.GA23412@in.ibm.com>
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150010.06126.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 07:57, Vivek Goyal wrote:
> Hi,
> 
> Here is another attempt on x86_64 relocatable bzImage patches(V4). This
> patchset makes a bzImage relocatable and same kernel binary can be loaded
> and run from different physical addresses.

I merged them all for now. Thanks.

-Andi
