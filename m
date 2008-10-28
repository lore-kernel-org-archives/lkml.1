Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ1E7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ1E7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYJ1E7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:59:41 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:47946 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYJ1E7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:59:41 -0400
Date: Tue, 28 Oct 2008 00:59:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] sony-laptop: Ignore missing _DIS method on pic device
In-reply-to: <20081016224903.GD21963@inferi.kami.home>
X-X-Sender: lenb@localhost.localdomain
To: Mattia Dongili <malattia@linux.it>
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0810280059030.24123@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1224192550-366-1-git-send-email-ajax@redhat.com>
 <20081016224903.GD21963@inferi.kami.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> > At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
> > to suspend just because it doesn't exist.

> > Signed-off-by: Adam Jackson <ajax@redhat.com>

> Acked-by: Mattia Dongili <malattia@linux.it>

applied to acpi-test

thanks,
-len
