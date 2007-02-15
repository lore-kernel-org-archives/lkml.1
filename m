Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXBOUyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXBOUyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:54:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXBOUyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:54:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:42788 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161228AbXBOUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=kmOD37+72d6Zm2SxdWNwS2voLbYUJcTChyuBj1P8vIcsLjgEpSAOK+nWNnCMZ//Ptm0YU6T4YWhhLkuQuuUoFY7EFTHOkUNnC9lrSSUBAzNgOAlPx65LNxtUmBWKesIJNrAnDrNqlRhY5hoiFPsAtBacwyczqHitdFlnRMEUkpY=
From: Maxim <maximlevitsky@gmail.com>
To: netdev@kernel.org
Subject: [PATCH 2.6.20 000/005] [RESEND v2] dmfe: number of fixes and features
Date: Thu, 15 Feb 2007 22:53:53 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702152253.53680.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
	Here I am resending revised and hopefully last version of patches I have prepared for DMFE driver.

As it was suggested to me I did revert commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 that adds basic link support.
So those patches will apply cleanly to 2.6.19 or 2.6.20 with this commit reverted.


Looking for comments, Maxim Levitsky

