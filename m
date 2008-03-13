Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbYCMFjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbYCMFjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYCMFjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:39:16 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59746 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025AbYCMFjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:39:15 -0400
Message-ID: <47D8BE08.6040800@davidnewall.com>
Date: Thu, 13 Mar 2008 16:09:20 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803102050.40567.phillips@phunq.net> <20080312131133.60e99d29@the-village.bc.nu> <200803121029.54108.phillips@phunq.net>
In-Reply-To: <200803121029.54108.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> Particularly about Ext2/Ext3, which does recover well from random damage.
> My experience.


By "recover well", you must mean "loses massive swabs of data, leaving
the system unbootable and with enormous numbers of user files missing." 
My experience.

Expecting fsck to cover for missed writes is stupid.
