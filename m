Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZAFVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZAFVul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZAFVua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:50:30 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47566 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbZAFVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:50:29 -0500
Subject: Re: need fusion driver guide
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux linux <linux.tina@gmail.com>,
       linux-scsi@vger.kernel.org
In-Reply-To: <20090106214538.GA18370@uranus.ravnborg.org>
References: <20090106214538.GA18370@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:50:25 -0600
Message-Id: <1231278625.10475.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 22:45 +0100, Sam Ravnborg wrote:
> [I forward this mail on request of Tina as her
> mails to lkml are lost somehow. /Sam ]

Best guess would be non plain text (i.e. having html components).  vger
is pretty keen on eating those as part of its spam filtering.

> I am new in scsi fusion driver code.
> i got some error in fusion driver. But i do not understand how fusion and
> scsi are working in kernel.
> can anyone please let me know wher i can get much info about this.

The best docs we have is the source.  LSI can provide the reference
manuals under NDA.

James


