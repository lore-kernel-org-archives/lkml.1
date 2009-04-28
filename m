Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbZD1ON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbZD1ON4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZD1ONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:13:46 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:58006 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbZD1ONp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:13:45 -0400
Date: Tue, 28 Apr 2009 16:13:42 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>, fenkes@de.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [ewg] Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
Message-ID: <20090428161342.2037c8fc@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <adabpqgx4g3.fsf@cisco.com>
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
	<adaws9dvrkp.fsf@cisco.com>
	<200904221602.29028.ossrosch@linux.vnet.ibm.com>
	<20090428150736.1ea143f0@BL3D1974.boeblingen.de.ibm.com>
	<adabpqgx4g3.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 07:01:32 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > did you have a chance to take a look at the patchset and will you apply it, or
>  > are there any outstanding issues we need to address?
> 
> I guess it's OK, but definitely 2.6.31 material.  I guess I'll stick it
> linux-next soon.
> 
>  - R.

Okay with us, thank you very much!

Alex
