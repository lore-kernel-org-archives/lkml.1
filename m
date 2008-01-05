Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYAEGtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYAEGtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 01:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYAEGsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 01:48:55 -0500
Received: from gw.goop.org ([64.81.55.164]:36808 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYAEGsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 01:48:55 -0500
Message-ID: <477F2823.2050300@goop.org>
Date: Fri, 04 Jan 2008 22:48:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH CPA] [4/28] Add pte_clrhuge on i386
References: <20080103424.989432000@suse.de> <20080103152418.3B54814E23@wotan.suse.de>
In-Reply-To: <20080103152418.3B54814E23@wotan.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 64bit had it already
>   

I'm unifying pgtable.h at the moment.  Will post soon.

    J
