Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbXI0P0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbXI0P0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXI0P0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:26:36 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15888 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbXI0P0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:26:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 27 Sep 2007 09:22:43 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
cc: "Marco Tralli" <marco.tralli@snapon.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Message-ID: <20070927152243.GF30917@cosmic.amd.com>
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
 <200709271730.14555.Rafal.Wysocki@fuw.edu.pl>
MIME-Version: 1.0
In-Reply-To: <200709271730.14555.Rafal.Wysocki@fuw.edu.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Sep 2007 15:22:16.0297 (UTC)
 FILETIME=[2FCF9590:01C8011A]
X-WSS-ID: 6AE515242ZC455755-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/07 17:30 +0200, R. J. Wysocki wrote:
> On Thursday, 27 September 2007 16:44, Marco Tralli wrote:
> > Hello all,
> > 
> > I have random hangs on kernel boot or after few minutes on a NatSemi Geode
> > GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system locks,
> > no way to use SysRq key, no usefull logs.
> 
> Please see: http://bugzilla.kernel.org/show_bug.cgi?id=9086

Thats a different bug, I believe.  The symptoms are different.  Plus, that
was a more modern LX processor, while this is a GX1 which doesn't share
any code with the LX BIOS, so it would be a huge coincidence if they were
affected by the same problem.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


