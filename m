Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZFQQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZFQQYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZFQQYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:24:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680AbZFQQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:24:07 -0400
Date: Wed, 17 Jun 2009 09:23:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <20090617134311.GR19977@parisc-linux.org>
Message-ID: <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio> <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Matthew Wilcox wrote:
> 
> Anyway, this should fix pci_claim_resource (untested):

Ack. This looks very sane. I'll happily commit this, but would be even 
happier to hear that it got some testing too, so I'll hold off for a 
while.

		Linus
