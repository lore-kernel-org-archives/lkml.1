Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZAaWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZAaWrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 17:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZAaWrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 17:47:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAaWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 17:47:04 -0500
Message-ID: <4984D40B.70203@zytor.com>
Date: Sat, 31 Jan 2009 14:43:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org> <4983FAB9.2010004@goop.org>
In-Reply-To: <4983FAB9.2010004@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Thanks.  I have a couple of additional fixes.  Also, did you pick up
> those other two io.h patches I mailed you the other day?
> 

Haven't yet, but it's on the TODO list for today (Friday got a bit busy.)

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

