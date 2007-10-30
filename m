Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXJ3RSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXJ3RSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJ3RSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:18:15 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:44475 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbXJ3RSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:18:14 -0400
Subject: RE: [PATCH 1/8] scsi: megaraid_sas - add hibernation support
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       "Patro, Sumant" <Sumant.Patro@lsi.com>
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
References: <1191253256.5850.4.camel@dhcp-75-534.se.lsil.com>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 12:18:12 -0500
Message-Id: <1193764692.3321.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 14:26 -0600, Yang, Bo wrote:
> James,
>  
> We submitted the "03.16-rc1" (megaraid_sas) patches about three weeks
> back.  Do you have any feedback or we need to re-submit the patches?

Randy Dunlap asked you why the module parameters were invisible ... is
there a reason (if not the patch needs to be updated to make them
visible and writeable by root).

James



