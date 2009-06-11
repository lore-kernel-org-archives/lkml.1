Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbZFKCr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbZFKCr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbZFKCrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:47:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:54978 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759459AbZFKCrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:47:42 -0400
Cc: Timur Tabi <timur@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       David Hawkins <dwh@ovro.caltech.edu>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <09185A86-F744-4302-A78A-04E1FFFA32BD@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <e9c3a7c20904271349m134ff7f2s9d7901015454cf3d@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Date: Wed, 10 Jun 2009 21:45:26 -0500
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com> <20090427204213.GA4960@ovro.caltech.edu> <49F619C4.20100@freescale.com> <e9c3a7c20904271349m134ff7f2s9d7901015454cf3d@mail.gmail.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27, 2009, at 3:49 PM, Dan Williams wrote:

> On Mon, Apr 27, 2009 at 1:47 PM, Timur Tabi <timur@freescale.com>  
> wrote:
>> Adding Kumar to the CC: list, since he might pick up the patch.
>>
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> I agree with taking this through Kumar's tree.

I'm going through patches for .31.. Should I still pick this up?   
Going forward should I pick up fsldma patches?

- k
