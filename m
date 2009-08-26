Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZHZUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZHZUPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZHZUPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:15:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZHZUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:15:48 -0400
Date: Wed, 26 Aug 2009 13:15:45 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Borislav Petkov <petkovbb@googlemail.com>
cc: mmi@superbash.de, LKML <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>, r.marek@assembler.cz
Subject: Re: AMD K10 temp.module ready since months, but missing in
 kernel...
In-Reply-To: <20090821104533.GA3872@liondog.tnic>
Message-ID: <alpine.DEB.2.01.0908261314300.5744@bogon.housecafe.de>
References: <20090821001322.470bb177@p4laptop> <20090821104533.GA3872@liondog.tnic>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX199N4NmNRdpKkDJnCXLvuUX053fLBw9V/QW2cC
 M1psLCsw/iZUJAy7T69hbbfC7TlX+LJLPI2VA/CMmmAABxcpaE
 iiQKfd0qG/vPgj4ghf7YA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 at 12:45, Borislav Petkov wrote:
> On Fri, Aug 21, 2009 at 12:13:22AM +0200, mmi wrote:
> > Hello out there,
> > 
> > i found the code to read temperature of AMD K10 (Phenom) processors a
> > couple of months ago in the net (GPL). I use it since January now and i
> > wonder, why it's not in the kernel till now.
> > 
> > It's from the same author, who wrote k8temp.c (which is in kernel).

MMI, do you mean this:
http://linux.derkeiler.com/Newsgroups/alt.os.linux/2008-08/msg00398.html

...or which code are you referring to?

Christian.
-- 
BOFH excuse #12:

dry joints on cable plug
