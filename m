Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbYCSVw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbYCSVw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYCSUUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:20:18 -0400
Received: from main.gmane.org ([80.91.229.2]:33111 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbYCSUUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: ultrastor.c is a bit-rot
Date: Tue, 18 Mar 2008 23:07:11 +0100
Message-ID: <m363vj1yb4.fsf@ursa.amorsen.dk>
References: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:ze5jCxTbQPT0H+UVffe4lYOoCNs=
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> writes:

> if the machine has more then 2^24 of memory. Then this will never
> work, right? or I'm missing it completely?

I used to have a machine with the VL-bus version of that card. I spent
a fortune upgrading that machine from 8x1MB to 4x4MB + 4x1MB, so it
did indeed work with larger than 16MB. The card got awfully hot and it
only worked when clocked at 33MHz (not the 40MHz the PC could do
without the card), but otherwise it worked fine.

I'm not sure whether that machine made it to kernel 2.0 though.


/Benny


