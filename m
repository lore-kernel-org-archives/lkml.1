Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYAEVaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYAEVaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYAEVaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:30:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:25796 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbYAEVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:30:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=omwqZdTL2SlaYr9zBW8lVyikZF08LnUgZl/Xd3oNm/Y15xDgozd+noLjw/RMEEK6d9o5BFcSXmCF5smXCOTLlPDn2uU5Xoe8VVN9rfxSg1Uhr+G7+IRa/HMOmvNJFVOeRq71kRWtN2hyHPO+LUQonPryGz958lZkET4PLRIYwxo=
Date: Sun, 6 Jan 2008 01:30:28 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080106013028.3e4dfcbe@linux.localdomain>
In-Reply-To: <20080105212050.GA2434@martell.zuzino.mipt.ru>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
	<20080105173601.75370546@linux.localdomain>
	<18303.38257.850625.70108@harpo.it.uu.se>
	<20080105184656.52b1f7d3@linux.localdomain>
	<20080105201622.GL27894@ZenIV.linux.org.uk>
	<20080106003034.15a75d4c@linux.localdomain>
	<20080105212050.GA2434@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 00:20:50 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> netconsole should be more quick:

Thanks a lot for the tip, I'll try that.

Alexander
