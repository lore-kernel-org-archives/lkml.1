Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYAQUU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYAQUU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYAQUUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:20:16 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:54301 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYAQUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:20:14 -0500
Date: Thu, 17 Jan 2008 21:20:24 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
Message-ID: <20080117202024.GA25090@aepfle.de>
References: <20080115150949.GA14089@aepfle.de> <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com> <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com> <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com> <20080117195456.GA24901@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080117195456.GA24901@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, Olaf Hering wrote:

> Since -mm boots further, what patch should I try?

rc8-mm1 crashes as well, l3 passed to reap_alien() is NULL.
