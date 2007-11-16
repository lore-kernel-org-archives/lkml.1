Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXKPWSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXKPWSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXKPWSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:18:34 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:45067 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164AbXKPWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:18:33 -0500
Subject: RE: [PATCH 1/6] scsi: megaraid_sas - add hibernation support
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       "Patro, Sumant" <Sumant.Patro@lsi.com>
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 16:18:25 -0600
Message-Id: <1195251505.3407.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 14:31 -0700, Yang, Bo wrote:
> James,
> 
> Do you have get any feedback for those patches?  Based on those patches
> be added to the scsi_misc tree, we have more patches need to submit.
> Please let me know.

Well, the last one had a large amount of whitespace cleanup to do:

Warning: trailing whitespace in lines
4,9,15,29,34,38,40,46,58,64,77,83,104,108,113,121,125,128,134,137,138 of
Documentation/scsi/ChangeLog.megaraid_sas

So it took me a while to clean it up.

James


