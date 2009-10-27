Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZJ0MzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZJ0MzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZJ0MzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:55:09 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:55550 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbZJ0Myi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:54:38 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Warning: dev (pts2) tty->count(4) != #fd's(3) in tty_release_dev
Date: Tue, 27 Oct 2009 12:16:23 +0100
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910271216.24214.elendil@planet.nl>
X-OriginalArrivalTime: 27 Oct 2009 12:54:41.0155 (UTC) FILETIME=[A617E530:01CA5704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v2.6.32-rc5-81-g964fe08 I just got this warning:
   Warning: dev (pts2) tty->count(4) != #fd's(3) in tty_release_dev

I've not had any tty problems with earlier kernels. I was running 
v2.6.32-rc4-1-gd93a8f8 before this.

Cheers,
FJP
