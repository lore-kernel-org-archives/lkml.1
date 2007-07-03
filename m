Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXGCPty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXGCPty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbXGCPtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:49:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48355 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758704AbXGCPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:49:38 -0400
Date: Tue, 3 Jul 2007 08:49:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/slub.c: make code static
In-Reply-To: <20070701202341.GW10869@stusta.de>
Message-ID: <Pine.LNX.4.64.0707030849220.4501@schroedinger.engr.sgi.com>
References: <20070701202341.GW10869@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007, Adrian Bunk wrote:

> This patch makes some needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Christoph Lameter <clameter@sgi.com>

