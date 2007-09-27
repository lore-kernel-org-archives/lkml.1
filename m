Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXI0Pu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXI0Pu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXI0Pus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:50:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbXI0Pur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:50:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 18:05:06 +0200
User-Agent: KMail/1.9.5
Cc: "Marco Tralli" <marco.tralli@snapon.com>, linux-kernel@vger.kernel.org
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com> <200709271730.14555.Rafal.Wysocki@fuw.edu.pl> <20070927152243.GF30917@cosmic.amd.com>
In-Reply-To: <20070927152243.GF30917@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271805.06758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 17:22, Jordan Crouse wrote:
> On 27/09/07 17:30 +0200, R. J. Wysocki wrote:
> > On Thursday, 27 September 2007 16:44, Marco Tralli wrote:
> > > Hello all,
> > > 
> > > I have random hangs on kernel boot or after few minutes on a NatSemi Geode
> > > GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system locks,
> > > no way to use SysRq key, no usefull logs.
> > 
> > Please see: http://bugzilla.kernel.org/show_bug.cgi?id=9086
> 
> Thats a different bug, I believe.  The symptoms are different.  Plus, that
> was a more modern LX processor, while this is a GX1 which doesn't share
> any code with the LX BIOS, so it would be a huge coincidence if they were
> affected by the same problem.

Well, I'd check anyway. :-)

Greetings,
Rafael
