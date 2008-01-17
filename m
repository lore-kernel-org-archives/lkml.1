Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYAQTDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYAQTDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYAQTDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:03:35 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53940 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751759AbYAQTDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:03:34 -0500
Date: Thu, 17 Jan 2008 11:03:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080117181222.GA24411@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801171102380.21204@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you try Pekka's suggestion of reverting  
04231b3002ac53f8a64a7bd142fde3fa4b6808c6 ?

