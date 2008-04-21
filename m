Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYDUHWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYDUHWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYDUHWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:22:42 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:42302 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYDUHWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:22:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:To:Cc:Subject:References:In-Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
	b=U2ULbSjCyWsKZrG+o9DoXX5g/gIyuOV6k0xXGn2L4DPuEPQsaspAN8bxwJil5sRQYR0ye9oSkZaMMAxk/qNfjah9GI4568+gkibqLYWm1OY5vPaL02W2W/5qtjqEtT10bqBsYOVLVAGmUJdhdRKQV5oHSzmUgx0C31vT4e5H9OY=;
Message-ID: <20080421082049.dduawz94j0s0o0c4@unsolicited.net>
Date: Mon, 21 Apr 2008 08:20:49 +0100
From: David R <david@unsolicited.net>
To: Andrew Morgan <morgan@kernel.org>
Cc: serge@hallyn.com, casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com>
	<480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com>
	<480BE354.408@kernel.org>
In-Reply-To: <480BE354.408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan <morgan@kernel.org>:

> David, can you run strace on the failing program (configuration)?

I'll not be able to do that 'till this evening (GMT+1), but will post  
an strace then.

Cheers
David

