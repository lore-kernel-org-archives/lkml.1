Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYDMPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYDMPlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYDMPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:41:09 -0400
Received: from rtr.ca ([76.10.145.34]:1380 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbYDMPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:41:08 -0400
Message-ID: <4802298F.7070708@rtr.ca>
Date: Sun, 13 Apr 2008 11:41:03 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Christian Pernegger <pernegger@gmail.com>,
       "Tvrtko A. Ursulin" <tvrtko@ursulin.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Western Digital GreenPower drives and Linux
References: <200804092118.35501.tvrtko@ursulin.net>  <200804100848.08442.tvrtko@ursulin.net>  <1207831481.1514.8.camel@localhost> <bb145bd20804100801y157b4a34m82f084d27f1e0586@mail.gmail.com> <alpine.LNX.1.10.0804121903200.8405@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0804121903200.8405@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>
> WD is not the first to do this unload nonsense,
..

Indeed.  Seagate beat them to it by a decade or so.
Hence the hdparm -Z flag for old Seagate drives.  :)
