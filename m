Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZGURSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZGURSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZGURSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:18:07 -0400
Received: from tango.0pointer.de ([85.214.72.216]:41507 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZGURSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:18:07 -0400
Date: Tue, 21 Jul 2009 19:17:41 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can access to /proc/$PID/exe be relaxed?
Message-ID: <20090721171741.GA28764@tango.0pointer.de>
References: <20090721165248.GA27549@tango.0pointer.de> <1158166a0907211006u5e2933f8y40dd2c56055bfc93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0907211006u5e2933f8y40dd2c56055bfc93@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21.07.09 19:06, Denys Vlasenko (vda.linux@googlemail.com) wrote:

> 
> On Tue, Jul 21, 2009 at 6:52 PM, Lennart Poettering<mzxreary@0pointer.de> wrote:
> > Hi!
> >
> > Unless I am mistaken a process currently needs CAP_SYS_PTRACE to read
> > /proc/$PID/exe for abritrary processes.
> 
> You mean "readlink'?

Yes.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
