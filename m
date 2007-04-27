Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbXD0Ke4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbXD0Ke4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXD0Ke4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:34:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbXD0Kez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:34:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: MAINTAINERS file out of date?
Date: Fri, 27 Apr 2007 12:34:32 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org
References: <4631255F.9010902@eridani.co.uk> <m1647ijvk1.fsf@ebiederm.dsl.xmission.com> <4631873B.1000107@zytor.com>
In-Reply-To: <4631873B.1000107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271234.32679.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> A lot of that code (although, of course, not all) could be written in C,
> though.  I'm thinking of taking a stab at rewriting it that way.

That would require a new compiler, right? I don't think that would
make users very happy.

Besides the code is not exactly that maintenance intensive and only
changes rarely so I don't need a pressing need to rewrite it

-Andi
 
