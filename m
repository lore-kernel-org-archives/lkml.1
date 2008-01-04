Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbYADCnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbYADCnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYADCnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:43:41 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:38723 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYADCnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:43:40 -0500
Message-ID: <477D9D66.3080502@tlinx.org>
Date: Thu, 03 Jan 2008 18:43:50 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no> <fa.1kDEq2SPE3FqpM5Mfw9CVGbvVdY@ifi.uio.no> <fa.hIZ5+XhGRugySB/HuLxr5qd6gAY@ifi.uio.no> <fa.iefWPg3R6g5Pnm/ktSCK9XWVFVw@ifi.uio.no> <fa.FhpaleM/osLTMJ85/PuxjxyJeGI@ifi.uio.no> <fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no> <477D9B6E.7060000@shaw.ca>
In-Reply-To: <477D9B6E.7060000@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>
> Looks like the drive reports ERR/ABRT (command aborted), meaning it 
> likely doesn't support those commands.
>
---
    Except the PATA version of the drive does (same capacity, & other 
specs).  Seagate would
disable "advanced" features for SATA but leave them for the older 
technology?  Possible,
but doesn't seem likely.


