Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXKMFZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXKMFZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXKMFY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:24:58 -0500
Received: from usul.saidi.cx ([204.11.33.34]:37280 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752067AbXKMFY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:24:57 -0500
Message-ID: <47393521.6060207@overt.org>
Date: Mon, 12 Nov 2007 21:24:49 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: mark.langsdorf@amd.com, LKML <linux-kernel@vger.kernel.org>
Subject: powernow-k8 and non-standard multipliers
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I've just upgraded to an X2 5000+ black edition. This model
doesn't have a multiple lock and I tried bumping the multiplier
up, which is perfectly stable, but which causes powernow-k8 to
fail to load. I also tried with the updated patch you posted
at the beginning of october (http://lkml.org/lkml/2007/10/9/224)
which didn't make a difference.

Is it possible to make the driver work in this situation or does
a non-standard multipler inherently mean that powernow stops
working?

Thanks,

--phil
