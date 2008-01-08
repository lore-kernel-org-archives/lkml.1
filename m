Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbYAHP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbYAHP46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbYAHP4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:56:47 -0500
Received: from dvhart.com ([64.146.134.43]:53685 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbYAHP4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:56:46 -0500
Message-ID: <47839D3C.1090106@mbligh.org>
Date: Tue, 08 Jan 2008 07:56:44 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: change SCSI owner in bugzilla
References: <20080106161635.GL2082@does.not.exist> <47828CC7.7060106@mbligh.org> <200801072147.53011.rjw@sisk.pl> <20080108100752.GA6906@elte.hu>
In-Reply-To: <20080108100752.GA6906@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>>> OK, changed it.
>>>
>>> I don't think this is the right way to do it, as you'll get email 
>>> for every change to every bug until it's assigned, but seeing as 
>>> that's what you asked for, and we can't seem to get vger to take 
>>> bounces, I guess it'll do.
>>>
>>> Let me know if (a) it works OK, and (b) you want the driver ones 
>>> changed over as well.
>> BTW, would that be possible to forward messages sent to
>> power-management_other@kernel-bugs.osdl.org to
>> linux-pm@lists.linux-foundation.org?
> 
> stupid question: why isnt this done via what most maintainers do, to set 
> up your bugzilla account to generate notifications of the special 
> power-management_other@kernel-bugs.osdl.org bugzilla user?

That would be better. Creating "users" for mailing lists may be
problematic - if it is, let me know.

M.

