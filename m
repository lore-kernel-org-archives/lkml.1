Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYCHHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYCHHMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 02:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYCHHMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 02:12:14 -0500
Received: from smtp-4.orange.nl ([193.252.22.249]:40854 "EHLO smtp-4.orange.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYCHHMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 02:12:13 -0500
X-ME-UUID: 20080308071210896.DAF3E7000082@mwinf6304.orange.nl
Message-ID: <47D23C4A.1030409@zonnet.nl>
Date: Sat, 08 Mar 2008 08:12:10 +0100
From: belcampo <belcampo@zonnet.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Snook <csnook@redhat.com>,
       Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug>	<47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com> <87zltae3y7.fsf@basil.nowhere.org>
In-Reply-To: <87zltae3y7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Back to basics:

Kernel 2.6.22.9 smp hyperthreading needs 338.143s
with 2.6.17 kernel smp/hyperthreading needs 247.704s
for exactly the same job on the same machine.

For me it's not about HT vs. non-MT

Henk Schoneveld

