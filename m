Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbXFOC7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbXFOC7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbXFOC7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:59:43 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38183
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXFOC7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:59:42 -0400
Date: Thu, 14 Jun 2007 19:58:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: NeilBrown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: limits on raid
Message-ID: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

what is the limit for the number of devices that can be in a single array?

I'm trying to build a 45x750G array and want to experiment with the 
different configurations. I'm trying to start with raid6, but mdadm is 
complaining about an invalid number of drives

David Lang
