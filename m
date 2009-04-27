Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZD0Uoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZD0Uoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbZD0Uop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:44:45 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:45613 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZD0Uoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:44:44 -0400
Message-ID: <49F6193A.2050301@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 13:44:42 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com> <49F6187F.8020703@ovro.caltech.edu> <49F618D1.2050109@freescale.com>
In-Reply-To: <49F618D1.2050109@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 13:44:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> David Hawkins wrote:
> 
>> Ira will add your comment to the body of the code near
>> the PRC_RM command and submit a new patch.
> 
> I'd rather have it near the top where people can see it.

Looks like Ira had the same thought :)

Dave


