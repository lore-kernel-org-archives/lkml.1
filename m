Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYAPSBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYAPSBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYAPSB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:01:27 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:10572 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYAPSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:01:27 -0500
To: travis@sgi.com
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with large count NR_CPUs V3
Cc: ak@suse.de, akpm@linux-foundation.org, clameter@sgi.com,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mingo@elte.hu, steiner@sgi.com
In-reply-To: <20080116170902.006151000@sgi.com>
References: <20080116170902.006151000@sgi.com>
Message-Id: <E1JFCZo-000618-8r@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 16 Jan 2008 19:01:24 +0100
X-OriginalArrivalTime: 16 Jan 2008 18:01:24.0504 (UTC) FILETIME=[CED69980:01C85869]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

travis@sgi.com wrote:
>    8472457 Total          30486950 +259%          30342823 +258%

Hmmm. The table for previous versions looked a lot more impressive.

now:    8472457 Total	 +22014493 +259%	 +21870366 +258%
V2 :    7172678 Total    +23314404 +325%           -147590   -2%
(recalculated for comparison)

Did something go wrong with the "after" data?
