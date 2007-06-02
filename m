Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbXFBX0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbXFBX0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762291AbXFBX0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:26:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46319 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762288AbXFBX0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:26:48 -0400
Date: Sat, 2 Jun 2007 16:26:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make arch/i386/mm/pgtable.c:pgd_{c,d}tor() static
In-Reply-To: <20070602190844.GJ5500@stusta.de>
Message-ID: <Pine.LNX.4.64.0706021626290.15432@schroedinger.engr.sgi.com>
References: <20070602190844.GJ5500@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Adrian Bunk wrote:

> pgd_{c,d}tor() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Christoph Lameter <clameter@sgi.com>
