Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXIMJVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXIMJVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXIMJVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:21:46 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:39267 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbXIMJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:21:45 -0400
Message-ID: <46E8FFB7.5010508@aitel.hist.no>
Date: Thu, 13 Sep 2007 11:15:35 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Stef Epardaud <stef@epardaud.net>
CC: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Resolved: bad RAM] Filesystem silent crash with EXT3
References: <20070912120203.GA23510@inforealm.org> <m3hcm0dm6z.fsf@maximus.localdomain> <20070912141604.GB24461@inforealm.org>
In-Reply-To: <20070912141604.GB24461@inforealm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stef Epardaud wrote:
> I feel like a fool now. You're absolutely right, my RAM is corrupted.
> Sorry for the trouble folks, I'm very happy to come to the conclusion I
> can rely on EXT3. Now I have to start worrying about how to detect RAM
> corruption before it screws up my data next time.
That is what memory with parity is for. Don't know if
that exists for laptops though.

Helge Hafting
