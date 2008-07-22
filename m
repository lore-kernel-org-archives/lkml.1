Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYGVOVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYGVOVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYGVOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:21:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:40562 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYGVOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:21:45 -0400
Date: Tue, 22 Jul 2008 10:21:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 128 GiB memory question-- kernel only sees 64GiB?
Message-ID: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To be able to utilize 128 GiB of memory on a host, does one need to enable 
NUMA support? Currently only 64 GiB is showing up.

As far as machine name/motherboard type, I do not have this information 
currently but I am told there are one or two of these boxes are running 
CentOS 5.x and/or RHEL5/AS.

Is there something special you need to do to utilize all 128 GiB of 
memory?

Thanks,

Justin.
