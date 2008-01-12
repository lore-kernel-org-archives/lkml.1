Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbYALBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbYALBlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbYALBl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:41:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbYALBl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:41:26 -0500
Date: Sat, 12 Jan 2008 02:41:17 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Bodo Eggert <7eggert@gmx.de>, Matthias Schniedermeyer <ms@citd.de>,
       Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <20080111183927.GM2310@csclub.uwaterloo.ca>
Message-ID: <alpine.LSU.0.999.0801120236500.9944@be1.lrz>
References: <9JpbI-5yi-9@gated-at.bofh.it> <9Jqri-7ym-17@gated-at.bofh.it>
 <9JqUn-8bF-15@gated-at.bofh.it> <9JvKj-85h-41@gated-at.bofh.it>
 <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org>
 <20080111183927.GM2310@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/+vADAlnzvwkQr8aHnliEt4/EvtkIuvouY0l4
 MmhxaOhtZOXL4oqHBknujciSRZeF0nJGvLU0SOw9gWs+7sueC+
 ORMq6NgAsYWpnLN7I6jRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008, Lennart Sorensen wrote:
> On Fri, Jan 11, 2008 at 05:22:45PM +0100, Bodo Eggert wrote:

> > What can happen if someone does tune2fs -Lroot /dev/usbstick
> > and puts that stick into this system?
> 
> Don't know.  I use UUIDs rather than LABELs.  Having duplicated labels
> just means being careless.  Having duplicate UUIDs should require being
> malicous.

That's exactly what you have to assume for your users. Otherwise, you could 
remove any security feature from the system.
-- 
Fun things to slip into your budget
Not in a budget, but in an annual report:
An employee stole 500,000+. They accounted for it on the annual report as
'involountary employee relations expense'
