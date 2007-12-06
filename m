Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbXLFWmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbXLFWmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXLFWmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:42:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59906 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbXLFWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:42:31 -0500
Date: Thu, 6 Dec 2007 23:42:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <david@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206224229.GJ20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <2BD0AF2A-959D-4744-9D2A-3AE84CF96CBB@mac.com> <47579DEB.9020102@davidnewall.com> <20071206163451.GB20595@one.firstfloor.org> <475875F9.3090503@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475875F9.3090503@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Renzo's IPN is a local protocol--you can't multicast to localhost.

You don't need to. All local clients can join the same group without
using localhost.

-Andi
