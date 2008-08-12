Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYHLWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYHLWUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYHLWUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:20:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYHLWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:20:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ia64 allmodconfig on current mainline
Date: Wed, 13 Aug 2008 00:22:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080812150608.231a948a.akpm@linux-foundation.org>
In-Reply-To: <20080812150608.231a948a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808130022.50501.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of August 2008, Andrew Morton wrote:
> /opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/bin/ia64-unknown-linux-gnu-ld: section .data [0000000004ea0000 -> 0000000004f656e7] overlaps section .data.percpu [0000000004e90000 -> 0000000004ea0d17]
> make: *** [.tmp_vmlinux1] Error 1

I gather this is a regression from .26?
