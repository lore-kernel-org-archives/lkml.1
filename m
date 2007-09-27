Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbXI0QJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbXI0QJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXI0QJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:09:22 -0400
Received: from SOKENS04e.snapon.com ([217.33.151.229]:39117 "EHLO
	sokens04.snapon.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722AbXI0QJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:09:21 -0400
Message-ID: <00cd01c80120$975e4ca0$7502a8c0@snaponglobal.com>
From: "Marco Tralli" <marco.tralli@snapon.com>
To: "Jordan Crouse" <jordan.crouse@amd.com>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Cc: <linux-kernel@vger.kernel.org>
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com> <200709271730.14555.Rafal.Wysocki@fuw.edu.pl> <20070927152243.GF30917@cosmic.amd.com>
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 18:05:31 +0200
Organization: SNAPON
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1807
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
X-OriginalArrivalTime: 27 Sep 2007 16:09:12.0068 (UTC) FILETIME=[BE242440:01C80120]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 27/09/07 17:30 +0200, R. J. Wysocki wrote:
> > On Thursday, 27 September 2007 16:44, Marco Tralli wrote:
> > > Hello all,
> > >
> > > I have random hangs on kernel boot or after few minutes on a NatSemi
Geode
> > > GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system
locks,
> > > no way to use SysRq key, no usefull logs.
> >
> > Please see: http://bugzilla.kernel.org/show_bug.cgi?id=9086
>
> Thats a different bug, I believe.  The symptoms are different.  Plus, that
> was a more modern LX processor, while this is a GX1 which doesn't share
> any code with the LX BIOS, so it would be a huge coincidence if they were
> affected by the same problem.
>


The same 2.6.23-rc6 kernel does not hang on Geode LX based PC-104 from
Advantech

I'm checking with 2.6.23-rc8-git2 and I'll let you know

Marco

