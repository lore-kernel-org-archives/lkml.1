Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYCYWaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYCYWaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCYWaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:30:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55162 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbYCYWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:30:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E97CC3.9050803@s5r6.in-berlin.de>
Date: Tue, 25 Mar 2008 23:29:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
References: <200803251647.16227.jwilson@redhat.com>
In-Reply-To: <200803251647.16227.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Just need to make sure we're freeing the correct memory

That would be a plus.  :-)

> Probably something we ought to sneak into 2.6.25 if its still doable...

Looks good and initial testing here is fine.  I don't have a board with 
IOMMU though.  Will look over it once more tomorrow, then submit it.
-- 
Stefan Richter
-=====-==--- --== ==--=
http://arcgraph.de/sr/
