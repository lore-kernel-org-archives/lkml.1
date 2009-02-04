Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZBDCQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZBDCQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZBDCQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:16:36 -0500
Received: from gw.goop.org ([64.81.55.164]:49597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZBDCQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:16:35 -0500
Message-ID: <4988FA82.3030905@goop.org>
Date: Tue, 03 Feb 2009 18:16:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org> <20090131161240.GA3014@elte.hu> <20090204021023.GA30736@elte.hu>
In-Reply-To: <20090204021023.GA30736@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> x86/paravirt is causing boot trouble on a 32-bit box - it reboots during 
> early bootup (it's a laptop so no easy access to its crashlog - if there's 
> any).
>
> config attached.

HPA just applied a patch which will likely fix this.  
0eb592dbba40baebec9cdde3ff4574185de6cbcc

    J
