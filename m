Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYDVF4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYDVF4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYDVF4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:56:19 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:36123 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYDVF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:56:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:Cc:Subject:References:In-Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
	b=NKWIkjsucODqoWL7Wc6yuBNpI3rD+EBdHn4BZF8nJVHqfmGhCi8x3O7n36hOyZm2g1OOwsID6eK2mL/px9LLoEORuGYqzAI08/6pnhFLCuCg+kUxfAoXRWDPJntXEKOVjRlujU7sEYzGJDcsl0M1CxX+xyYEhuSswXWhOigfs9E=;
Message-ID: <20080422065459.peswewk1qyzos04o@unsolicited.net>
Date: Tue, 22 Apr 2008 06:54:59 +0100
From: David R <david@unsolicited.net>
Cc: serge@hallyn.com, casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com>
	<480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com>
	<20080421080101.htzh4s03snescog4@unsolicited.net>
	<20080421183451.GA22071@vino.hallyn.com> <480CE167.8090907@unsolicited.net>
	<20080421190143.GA23365@vino.hallyn.com> <480CF8DB.9010405@unsolicited.net>
	<20080422024259.GA27223@vino.hallyn.com> <480D77AC.7080202@kernel.org>
In-Reply-To: <480D77AC.7080202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Andrew G. Morgan" <morgan@kernel.org>:

> As you have found, libcap2 does address your problem. I suspect that
> libcap-1.97 here:
>

I daresay it will, but libcap v2 sorts my problems out so I'm happy.  
It's unfortunate that old versions of SuSE shipped with buggy libcap  
as the breakage will be blamed on the kernel upgrade. One of those  
things I guess.

David



