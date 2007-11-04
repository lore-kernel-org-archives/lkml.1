Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXKDXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXKDXIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXKDXH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:07:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42658 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXKDXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:07:56 -0500
Date: Mon, 5 Nov 2007 00:07:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Snook <csnook@redhat.com>,
       Zurk Tech <zurktech@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
Message-ID: <20071104230753.GA4938@one.firstfloor.org>
References: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com> <472D2119.8090102@redhat.com> <p737ikx3ksn.fsf@bingen.suse.de> <1194211101.20832.3.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194211101.20832.3.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Would it not be as simple as looking at the BIOS provided topology
> information? If nr sockets > 4 assume multiple board.

There is no reason multiple two socket boards couldn't be connected
with HT cables to form a larger system. Then you might end up
with a 4 socket system with multiple oscillators.

-Andi
