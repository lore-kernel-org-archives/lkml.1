Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZA0RuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZA0RuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZA0Rtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:49:53 -0500
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:57637 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755530AbZA0Rtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:49:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uKaoaQtWZxs725XP9lMBAwG+HuhSwbKDnRn5Vpx0RuppFQDpv/aDadCrw3D4Tm68HQAlgSiKp8pkwYojILJxbdHPP79MI+VX71YyJYsLHrj1vKQm+G2QLoN+NzlE2rgu;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 2.6.29-rc2] irq: irq and pci_ids patch for Intel Tigerpoint DeviceIDs
Date: Tue, 27 Jan 2009 09:49:07 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       khali@linux-fr.org, x86@vger.kernel.org
References: <200901231243.38626.seth.heasley@intel.com>
In-Reply-To: <200901231243.38626.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901270949.08211.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2009 12:43 pm Seth Heasley wrote:
> This patch adds the Intel Tigerpoint LPC Controller DeviceIDs.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Applied this one to my for-linus branch.  Shouldn't hurt to add a new bridge 
ID for 2.6.29.

-- 
Jesse Barnes, Intel Open Source Technology Center
