Return-Path: <linux-kernel-owner+w=401wt.eu-S1031400AbXDJS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031400AbXDJS2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031404AbXDJS2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:28:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:45263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031400AbXDJS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:28:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 4/6] Rename the parainstructions symbols to be consistent with the others
Date: Tue, 10 Apr 2007 20:07:48 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20070404010655.400913479@goop.org> <20070404011453.598418421@goop.org>
In-Reply-To: <20070404011453.598418421@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102007.49163.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 03:06:59 Jeremy Fitzhardinge wrote:
> The other symbols used to delineate the alt-instructions sections have
> the form __foo/__foo_end.  Rename parainstructions to match.

This patch breaks x86-64

-Andi

> 
