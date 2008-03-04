Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbYCDMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbYCDMA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYCDMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:00:09 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54046 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbYCDL7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:59:46 -0500
Date: Tue, 4 Mar 2008 12:59:39 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1
Message-ID: <20080304125939.199a9f15@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 01:19:28 -0800,
Andrew Morton <akpm@linux-foundation.org> wrote:

> +driver-core-fix-cleanup-when-failing-device_add.patch

This should go into 2.6.25, as it fixes a panic (see
http://marc.info/?l=linux-kernel&m=120411157302447&w=2,
http://marc.info/?l=linux-kernel&m=120412001416810&w=2).
