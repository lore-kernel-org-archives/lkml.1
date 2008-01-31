Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYAaGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYAaGEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAaGEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:04:43 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:38974 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYAaGEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:04:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/6] Change RIO function mpc85xx_ to fsl_ .
Date: Thu, 31 Jan 2008 14:04:22 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEBD0683@zch01exm26.fsl.freescale.net>
In-Reply-To: <A3EAB036-F69D-48DD-8CA9-4EAAE63AE1F5@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/6] Change RIO function mpc85xx_ to fsl_ .
Thread-Index: AchjTpSrOvEQkANzT5ug6XdKAUGnXQAgA3GA
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <A3EAB036-F69D-48DD-8CA9-4EAAE63AE1F5@kernel.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All right, I'll give you another patch for 86xx dts file. :)

 Btw: Why the PCI and other nodes were moved from SOC? Just for clear?
If they are moved out, their register address must use full address not
offset address.

Thanks!
Wei.

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> Sent: Wednesday, January 30, 2008 10:44 PM
> To: Zhang Wei
> Cc: mporter@kernel.crashing.org; 
> linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH 1/6] Change RIO function mpc85xx_ to fsl_ .
> 
> Can you post a device tree update as well.
> 
> The older patches on the list for the 86xx .dts should NOT 
> put the rio  
> node under the soc.  It should be at the same level as PCI.
> 
> - k
> 
