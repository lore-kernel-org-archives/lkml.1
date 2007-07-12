Return-Path: <linux-kernel-owner+w=401wt.eu-S934305AbXGLNP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbXGLNP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763984AbXGLNPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:15:49 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60221 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761182AbXGLNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:15:48 -0400
Date: Thu, 12 Jul 2007 09:15:44 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: David Patrick Quigley <dpquigl@tycho.nsa.gov>
cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, eparis@redhat.com, sds@tycho.nsa.gov
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and
 powerpc
In-Reply-To: <1184244990.18175.6.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Line.LNX.4.64.0707120914370.1473@d.namei>
References: <20070710201200.GA10255@amitarora.in.ibm.com> 
 <20070710202000.GB8797@amitarora.in.ibm.com> <1184244990.18175.6.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, David Patrick Quigley wrote:

> From: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Revalidate the write permissions for fallocate(2), in case security policy has
> changed since the files were opened.
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

Acked-by: James Morris <jmorris@namei.org>


(Will need to check it's ok again after final merge).



-- 
James Morris
<jmorris@namei.org>
