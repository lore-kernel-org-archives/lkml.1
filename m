Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYLSBr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLSBr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 20:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYLSBrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 20:47:19 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:32944 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYLSBrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 20:47:18 -0500
Date: Fri, 19 Dec 2008 02:12:18 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Joerg Roedel <joerg.roedel@amd.com>,
       iommu@lists.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 gart: don't complain if no AMD GART found
Message-ID: <20081219001218.GB6764@il.ibm.com>
References: <20081217195234.13603.96737.stgit@bob.kio> <20081217202724.GB9475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217202724.GB9475@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 03:27:24PM -0500, Dave Jones wrote:

> The Calgary stuff is pretty noisy in the face of non-existant hardware too.
> Makes for noisy distro kernels..
> 
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!

Feel free to nuke it.

Cheers,
Muli
-- 
SYSTOR 2009---The Israeli Experimental Systems Conference
May 4-6, 2009, Haifa, Israel
http://www.haifa.il.ibm.com/conferences/systor2009/
