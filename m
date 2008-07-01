Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYGAPbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYGAPbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYGAPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:30:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:58792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbYGAPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:30:42 -0400
Date: Tue, 1 Jul 2008 08:30:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Agner Fog <agner@agner.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080701083036.32d20d1c@infradead.org>
In-Reply-To: <4865F0DA.2050906@agner.org>
References: <48626514.2040905@agner.org>
	<20080625092224.736c2541@infradead.org>
	<4862ECAB.1040402@zytor.com>
	<4864CFA5.9050901@agner.org>
	<20080627072231.7337ba18@infradead.org>
	<4865F0DA.2050906@agner.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 10:05:46 +0200
Agner Fog <agner@agner.org> wrote:

> Arjan van de Ven wrote:
>  >the good news is that we review drivers before they get included
>  >and 
> we do catch such things.
> 
> Are you saying that some group should have the monopoly of approving 
> device drivers? That is exectly the policy that Microsoft has been so 
> much criticized for. You can only control the drivers that are
> included in your own Linux distribution.

the linux model is that drivers (eventually) get included into the
linux kernel source code. Everything we do process wise is centered
around that concept.

Nothing prevents you from going outside the process. But you need to
realize that that is exactly that: outside the process. Meaning: you're
partially on your own.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
