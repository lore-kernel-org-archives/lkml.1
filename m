Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbZJMXyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbZJMXyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761637AbZJMXyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:54:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:44625 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761635AbZJMXyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:54:14 -0400
Date: Tue, 13 Oct 2009 19:53:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.3: coretemp module fails on i7 870 CPU
Message-ID: <alpine.DEB.2.00.0910131952170.29143@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

# uname -r
2.6.31.3

# modprobe coretemp
FATAL: Error inserting coretemp (/lib/modules/2.6.31.3/kernel/drivers/hwmon/coretemp.ko): No such device
Oct 13 19:52:08 p34 kernel: [ 9201.229084] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.254903] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.268091] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.281192] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.294058] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.306917] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.319488] coretemp: Unknown CPU model 1e
Oct 13 19:52:08 p34 kernel: [ 9201.332122] coretemp: Unknown CPU model 1e

Is there a patch in the latest -rcX for support for support for this model
CPU?

Justin.

