Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbYDNRoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbYDNRoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYDNRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:44:25 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:49835 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbYDNRoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:44:24 -0400
Message-ID: <44826.198.182.194.170.1208195063.squirrel@clueserver.org>
In-Reply-To: <20080414182918.4779b8ea@core>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
    <20080414175636.4ea815dc@core>
    <48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
    <20080414182918.4779b8ea@core>
Date: Mon, 14 Apr 2008 10:44:23 -0700 (PDT)
Subject: Re: Again... DMA speed too slow
From: "Alan" <alan@clueserver.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Joerg Schilling" <joerg.schilling@fokus.fraunhofer.de>,
       linux-kernel@vger.kernel.org, htejun@gmail.com
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I am not sure why you mention the term "brave", is it because all known
>> Linux
>> distributions still require suid root? In this case, I encourage you to
>> inform
>
> Last time I checked almost all cd burning was being done non root.

Nero for Linux seems to be an exception.  It wants to write to raw devices
that non-root users do not have permissions for.
