Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXCHOOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXCHOOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXCHOOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:14:45 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:47121 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXCHOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:14:44 -0500
To: Jan Marek <linux@hazard.jcu.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Problem with SCSI communication between Adaptec and Ecrix VXA1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20070308091634.GD6836@hazard.jcu.cz>
Date: Thu, 08 Mar 2007 09:13:51 -0500
In-Reply-To: <20070308091634.GD6836@hazard.jcu.cz> (Jan Marek's message of "Thu, 8 Mar 2007 10:16:34 +0100")
Message-ID: <yq1ps7jj00w.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Marek <linux@hazard.jcu.cz> writes:

Jan> Mar  7 07:47:53 rek kernel: st0: Error with sense data: <6>st0: Current: sense key=0x4
Jan> Mar  7 07:47:53 rek kernel:     ASC=0x44 ASCQ=0x0
Jan> Mar  7 07:47:53 rek kernel: Info fld=0x0
Jan> Mar  7 07:47:59 rek kernel: st0: Error with sense data: <6>st0: Current: sense key=0x4
Jan> Mar  7 07:47:59 rek kernel:     ASC=0x15 ASCQ=0x1
Jan> Mar  7 07:47:59 rek kernel: Info fld=0x0

Sense Key 0x4     = Hardware error
ASC 0x44/ASCQ 0x0 = Internal Target Failure
ASC 0x15/ASCQ 0x1 = Mechanical Positioning Error

-- 
Martin K. Petersen	Oracle Linux Engineering

