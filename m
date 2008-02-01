Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYBASle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYBASle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYBASlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:41:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54933 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYBASlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:41:20 -0500
Message-ID: <47A367CB.1080805@pobox.com>
Date: Fri, 01 Feb 2008 13:41:15 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: rl@hellgate.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] via-rhine.c:rhine_hw_init() must be __devinit
References: <20080130200205.GI29368@does.not.exist>
In-Reply-To: <20080130200205.GI29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied the net driver portion of these patches...


