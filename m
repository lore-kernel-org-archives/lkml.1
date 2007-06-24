Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXFXU31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXFXU31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXFXU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:29:20 -0400
Received: from lucidpixels.com ([75.144.35.66]:51739 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXFXU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:29:19 -0400
Date: Sun, 24 Jun 2007 16:29:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org, arjan@linux.intel.com
cc: Alan Piszcz <ap@solarrain.com>
Subject: IRQ Balance Question for Single but Multi-Core Processors
Message-ID: <Pine.LNX.4.64.0706241627470.5819@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question regarding the IRQ balance daemon and the 2.6.x kernel.

For a single-processor but dual or quad core CPU, should one be running 
the IRQ balancing daemon, will it result in increased performance?

Or is IRQ balance mainly targeted at physical multi-processor systems?

Justin.

