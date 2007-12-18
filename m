Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXLRXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXLRXP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXLRXPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:15:20 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:34713 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbXLRXPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:15:19 -0500
Date: Wed, 19 Dec 2007 00:07:26 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Steve Davies <davies147@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA Velocity and 802.1q VLAN support
Message-ID: <20071218230726.GA1876@electric-eye.fr.zoreil.com>
References: <5caa9b870712180945o17c797f7rb00a1b0d3fc12fc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5caa9b870712180945o17c797f7rb00a1b0d3fc12fc6@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Davies <davies147@gmail.com> :
[...]
> I assume that the NIC is not allowing tagged packets into the driver
> due to its built-in hardware acceleration/filtering :(
> 
> Is it inappropriate to beg for help and suggestions?

Try to disable the vlan related Rx filtering ?

-- 
Ueimor
