Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYIIM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYIIM7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYIIM7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:59:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIIM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:59:33 -0400
Date: Tue, 9 Sep 2008 15:03:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Janne Grunau <j@jannau.net>
Cc: Andi Kleen <andi@firstfloor.org>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080909130311.GA4085@one.firstfloor.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <87hc8ptzw7.fsf@basil.nowhere.org> <200809091335.17559.j@jannau.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809091335.17559.j@jannau.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> pr_printk is not found in include/ nor by google. please explain

pr_debug() sorry.

-Andi
