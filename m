Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZFLPF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZFLPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZFLPFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:05:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:44590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbZFLPFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:05:46 -0400
Cc: Ira Snyder <iws@ovro.caltech.edu>, Dan Williams <dan.j.williams@intel.com>,
       Timur Tabi <timur@freescale.com>, David Hawkins <dwh@ovro.caltech.edu>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <24633D89-D4EC-4C27-8B7F-3992EFE50989@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
In-Reply-To: <2a27d3730906120223w9f30b7ewfd22eb328e3a23d3@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Date: Fri, 12 Jun 2009 10:03:27 -0500
References: <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com> <20090427204213.GA4960@ovro.caltech.edu> <49F619C4.20100@freescale.com> <e9c3a7c20904271349m134ff7f2s9d7901015454cf3d@mail.gmail.com> <09185A86-F744-4302-A78A-04E1FFFA32BD@kernel.crashing.org> <20090611151750.GB9323@ovro.caltech.edu> <2a27d3730906120223w9f30b7ewfd22eb328e3a23d3@mail.gmail.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12, 2009, at 4:23 AM, Li Yang wrote:

> On Thu, Jun 11, 2009 at 11:17 PM, Ira Snyder<iws@ovro.caltech.edu>  
> wrote:
>> On Wed, Jun 10, 2009 at 09:45:26PM -0500, Kumar Gala wrote:
>>>
>>> On Apr 27, 2009, at 3:49 PM, Dan Williams wrote:
>>>
>>>> On Mon, Apr 27, 2009 at 1:47 PM, Timur Tabi <timur@freescale.com>
>>>> wrote:
>>>>> Adding Kumar to the CC: list, since he might pick up the patch.
>>>>>
>>>>
>>>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>>>>
>>>> I agree with taking this through Kumar's tree.
>>>
>>> I'm going through patches for .31.. Should I still pick this up?   
>>> Going
>>> forward should I pick up fsldma patches?
>>>
>>
>> I'm fine with that, but you should probably talk to Li Yang (added to
>> CC). He's gotten in contact with me a few times recently.
>
> I am fine with both ways for this patch as it is only related to
> Freescale register details.  But in general I think patches should go
> through functional subsystem, as they usually would need insight of
> the subsystem architecture.  I prefer the way that the patch acked or
> signed-off by Freescale guys and push upstream through Dan's tree as
> most other subsystems did.  Unless Dan prefers to ack the subsystem
> architectural part of each patch and have them pushed other way.

I agree w/this and just wanting to see what Dan's preference is.

- k
