Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXJaTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXJaTBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXJaTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:01:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55438 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967AbXJaTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:01:39 -0400
Date: Wed, 31 Oct 2007 12:01:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] mempolicy minor code cleanups
In-Reply-To: <20071031071203.21924.70083.sendpatchset@jackhammer.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0710311201010.21799@schroedinger.engr.sgi.com>
References: <20071031071203.21924.70083.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Some minor code cleanups for mm/mempolicy.c.

Hmmmm... Could you elaborate on why you moved certain things around and 
why another call into cpusets was added?
