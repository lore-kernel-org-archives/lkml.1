Return-Path: <linux-kernel-owner+w=401wt.eu-S1031440AbXDZStc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031440AbXDZStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031442AbXDZStc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:49:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51753 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031440AbXDZStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:49:31 -0400
Date: Thu, 26 Apr 2007 11:49:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
In-Reply-To: <4630F203.7020005@shadowen.org>
Message-ID: <Pine.LNX.4.64.0704261149120.6139@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
 <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
 <4630F203.7020005@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andy Whitcroft wrote:

> I am inclined to suggest we change it for BUG:
> 
> 	BUG(index < 0);
> 
> Perhaps only on older compilers.

I'd be fine with that solution.

