Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYAFUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYAFUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYAFUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:25:15 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:33484 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbYAFUZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:25:13 -0500
Message-ID: <47813926.6010908@tlinx.org>
Date: Sun, 06 Jan 2008 12:25:10 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no> <fa.1kDEq2SPE3FqpM5Mfw9CVGbvVdY@ifi.uio.no> <fa.hIZ5+XhGRugySB/HuLxr5qd6gAY@ifi.uio.no> <fa.iefWPg3R6g5Pnm/ktSCK9XWVFVw@ifi.uio.no> <fa.FhpaleM/osLTMJ85/PuxjxyJeGI@ifi.uio.no> <fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no> <477D9B6E.7060000@shaw.ca> <477D9D66.3080502@tlinx.org> <477DA05F.4080503@shaw.ca>
In-Reply-To: <477DA05F.4080503@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>
> If this is a Seagate, I believe that they don't have AAM enabled on 
> any of their newer drives (something about a lawsuit for patent 
> infringement on that feature, or something). Quite likely they don't 
> support that power management command, either.
--
    Do you have a source for this -- haven't heard of such a conflict -- 
besides, doesn't
ATA-7 require some of those functions?  Given the trend toward 
power-saving and
quieter (also usually less vibration)  hard disks, I strongly disbelieve 
Seagate would
remove those features -- especially since they are mentioned on 
Seagate's drive
information page as being supported features.



