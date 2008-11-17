Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYKQISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYKQISX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYKQISO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:18:14 -0500
Received: from cpsmtpo-eml05.KPNXCHANGE.COM ([213.75.38.154]:24827 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYKQISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:18:14 -0500
From: Frans Pop <elendil@planet.nl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Mon, 17 Nov 2008 09:18:08 +0100
User-Agent: KMail/1.9.9
Cc: Gerold Jury <gml@inode.at>, efault@gmx.de, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       vsu@altlinux.ru
References: <200802252005.22663.gml@inode.at> <E1JXic1-0000Yo-K8@faramir.fjphome.nl> <4920DF5C.3030400@gmail.com>
In-Reply-To: <4920DF5C.3030400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811170918.10516.elendil@planet.nl>
X-OriginalArrivalTime: 17 Nov 2008 08:18:11.0637 (UTC) FILETIME=[07DE5650:01C9488D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Tejun Heo wrote:
> Can you guys please add yourselves to bz#10743?
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=10743
>
> Please test 2.6.28-rc5 as it contains sata_via changes (TF access
> needed specific workaround) and see whether the problem is fixed and
> report on bz.

I cannot really help here. I never saw the problem myself, but just 
thought I saw some pattern in the breakage that might provide a clue.

Sorry,
FJP
