Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYIPJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYIPJf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYIPJfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:35:20 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57694 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173AbYIPJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:35:20 -0400
Date: Tue, 16 Sep 2008 10:35:13 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alessio Sangalli <alesan@manoweb.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
Message-ID: <20080916093513.GF1916@fluff.org.uk>
References: <48CEC71F.3000006@manoweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CEC71F.3000006@manoweb.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 01:35:43PM -0700, Alessio Sangalli wrote:
> Hi, the platform I am working on right now (ARM) has a so called 'TCM'
> (tightly coupled memory) that is some 8 to 32kB of SRAM in the chip, no
> waitstates, very high bandwidth, and it is possible to access it *while*
> accessing main memory. It may be a very good thing (for example) to
> implement a software FIFO to be used in ISRs or such.

This isn't the right list to be discussing this on, try looking for
linux-arm-kernel instead. It will get your question to the attention
of more people knowledgable about the ARM specifics.

> Do you know of any implementation of such software FIFO or any other
> kernel driver for TCMs?

IIRC, there's no current support for using TCMs.
 
> bye
> Alessio
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
