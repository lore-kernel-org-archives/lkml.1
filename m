Return-Path: <linux-kernel-owner+w=401wt.eu-S1764926AbYARSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764926AbYARSrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763344AbYARSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:47:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33254 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762946AbYARSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:47:35 -0500
Date: Fri, 18 Jan 2008 10:47:35 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080117211511.GA25320@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
 <20080117211511.GA25320@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Olaf Hering wrote:

> early_node_map[1] active PFN ranges
>     1:        0 ->   892928
> Could not find start_pfn for node 0

Corrupted min_pfn?

