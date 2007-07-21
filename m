Return-Path: <linux-kernel-owner+w=401wt.eu-S937776AbXGUIlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937776AbXGUIlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbXGUIkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:40:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36608 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937802AbXGUIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:40:45 -0400
Date: Sat, 21 Jul 2007 10:40:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: where is the code for read system call?
In-Reply-To: <20070721050544.GA27684@vanheusden.com>
Message-ID: <Pine.LNX.4.64.0707211040160.21737@fbirervta.pbzchgretzou.qr>
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com>
 <20070721050544.GA27684@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 07:05, Folkert van Heusden wrote:
>
>> My application reads from socket. I need to change the behavior of read
>> system call for an experiment. Can someone point me to code?
>
>Wouldn't it be easier to create a preload-library-wrapper around glibc?
>
Does not work with statically compiled binaries.
But in an experiment, you are likely to have source and/or dynamically linked
programs.


	Jan
-- 
