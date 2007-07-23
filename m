Return-Path: <linux-kernel-owner+w=401wt.eu-S934239AbXGWTTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239AbXGWTTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXGWTTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:19:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55780 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760012AbXGWTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:19:29 -0400
Date: Mon, 23 Jul 2007 12:19:22 -0700
From: Christoph Lameter <clameter@sgi.com>
To: "Marco Berizzi" <pupilla@hotmail.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, <linux-kernel@vger.kernel.org>,
       "David Chinner" <dgc@sgi.com>, <xfs@oss.sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: 2.6.21.3 Oops (was Re: XFS internal error xfs_da_do_buf(2) at
 line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd)
Message-ID: <20070723121922.1b347eac@schroedinger.engr.sgi.com>
In-Reply-To: <BAY103-DAV5C915E9475BFB6180B585B2170@phx.gbl>
References: <BAY103-DAV717DD455F57B3BB064E3CB2100@phx.gbl>
	<Pine.LNX.4.64.0706211121520.7711@schroedinger.engr.sgi.com>
	<BAY103-DAV5C915E9475BFB6180B585B2170@phx.gbl>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 11:22:09 +0200
"Marco Berizzi" <pupilla@hotmail.com> wrote:

> With the same kernel or should I compile with
> some other options?

With the same kernel. No additional options are needed. 
