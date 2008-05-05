Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYEENVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYEENVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYEENVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:21:12 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:32692 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbYEENVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:21:10 -0400
Message-ID: <481F09A2.6070206@de.ibm.com>
Date: Mon, 05 May 2008 15:20:34 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Martin_Jetter=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: mschwid2@linux.vnet.ibm.com
CC: Avi Kivity <avi@qumranet.com>, borntrae@linux.vnet.ibm.com,
       heicars2@linux.vnet.ibm.com, Adrian Bunk <bunk@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: s390 kvm_virtio.c build error
References: <20080503174716.GM5838@cs181133002.pp.htv.fi> <20080504192537.GA5499@osiris.boeblingen.de.ibm.com> <200805051429.47446.borntraeger@de.ibm.com> <481F0504.3010503@qumranet.com> <1209992810.7089.15.camel@localhost>
In-Reply-To: <1209992810.7089.15.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mschwid2@linux.vnet.ibm.com wrote:
> I've added Heiko's patch to my patchqueue. But since this is
> drivers/s390/kvm this should go in over the kvm.git. See patch below.
Acked-by: Carsten Otte <cotte@de.ibm.com>

