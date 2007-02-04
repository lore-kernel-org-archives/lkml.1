Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbXBDU0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbXBDU0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXBDU0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:26:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:5356 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXBDU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oq4iQ3nR6K02IEy9LYAyijOXzWPskoM5KLpfq1UIu+kqnTSS1VoNEDcwG18jDndV1cXsaf7njf/jJcrnV2kF8bajmnSMSagCBWemnEL69eW0rHmIFfGsWI1fvVD5FqvmocijxaI6Xdrap1xDMQ/JatjyMA4/YSdsakXibuj3mLw=
Message-ID: <767314830702041226o10d162e6u4f8b6e42baf600d5@mail.gmail.com>
Date: Sun, 4 Feb 2007 15:26:42 -0500
From: "Keenan Pepper" <keenanpepper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic worksperfectly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> From what version of the kernel did you upgrade?
> It is very helpful for us to knwo the latest version which worked OK.

The ata_piix driver never worked correctly. The last kernel I used,
2.6.17, used ide_generic by default, so the ata_piix bug never showed
up. Sorry if that was unclear.

Keenan
