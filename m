Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYCCSDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYCCSDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYCCSDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:03:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:38044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbYCCSDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:03:39 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance =?iso-8859-1?q?DEBUG=5FRODATA=09support_-?= alternatives"
Date: Mon, 3 Mar 2008 19:03:35 +0100
User-Agent: KMail/1.9.6
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
References: <47C86D7A.5030608@goop.org> <20080303173057.GA14598@Krystal> <47CC3C2B.6000807@goop.org>
In-Reply-To: <47CC3C2B.6000807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031903.35724.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 18:58:03 Jeremy Fitzhardinge wrote:

> Perhaps, though that's uncached by default.

ioremap_cached()

-Andi
