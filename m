Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYAGWBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYAGWBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYAGWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:00:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:33410 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbYAGWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:00:58 -0500
Subject: Re: New linux arch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michal Simek <simekm2@fel.cvut.cz>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu
In-Reply-To: <47820D24.3060800@fel.cvut.cz>
References: <47820D24.3060800@fel.cvut.cz>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 09:00:33 +1100
Message-Id: <1199743233.6734.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 21:29 +1000, Michal Simek wrote:
> Hi all,
> 
> I redesigned all files for microblaze cpu (xilinx fpga).
> All code is FDT compatible.

For those who don't know, FDT is the flattened device-tree format used
nowadays on PowerPC, based on the open firmware device-tree.

I'm really happy to see that being picked up by another architecture,
that's great !

Cheers,
Ben.


