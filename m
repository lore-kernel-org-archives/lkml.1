Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXGSMGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXGSMGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbXGSMGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:06:36 -0400
Received: from ns.suse.de ([195.135.220.2]:46486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765128AbXGSMGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:06:35 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Subject: Re: [PATCH] [2/58] x86_64: Tell gcc to only align stack to 8 bytes
Date: Thu, 19 Jul 2007 14:06:31 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095445.DC94514E04@wotan.suse.de> <87wswwsjcz.fsf@depni.sinp.msu.ru>
In-Reply-To: <87wswwsjcz.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191406.31857.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 13:50:20 Serge Belyshev wrote:

> So -mpreferred-stack-boundary=4 is the default and to align stack
> to 8 bytes you want -mpreferred-stack-boundary=3, not 4, IIUC.

Fixed thanks

-Andi


