Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbXGPOEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbXGPOEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXGPOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:01:48 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:16885 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290AbXGPOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:01:45 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: vraghavan3@mail.gatech.edu
Subject: Re: Reading BIOS flash memory
Date: Mon, 16 Jul 2007 16:01:25 +0200
User-Agent: KMail/1.9.7
cc: linux-kernel@vger.kernel.org
References: <1184592238.469b716ee5b68@webmail.mail.gatech.edu>
In-Reply-To: <1184592238.469b716ee5b68@webmail.mail.gatech.edu>
MIME-Version: 1.0
Message-ID: <200707161601.25764.joachim.deguara@amd.com>
X-OriginalArrivalTime: 16 Jul 2007 14:01:26.0875 (UTC)
 FILETIME=[CD2CC2B0:01C7C7B1]
X-WSS-ID: 6A85A5B1R0G2583289-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 15:23:58 vraghavan3@mail.gatech.edu wrote:
> --
> Hey,
>
> Are there functions to read the BIOS given the address? Does ioremap() work
> in this case too?

I can't answer that but take a look how flashrom [1] does it.

-Joachim

[1] http://linuxbios.org/Flashrom


