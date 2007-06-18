Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbXFRCFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbXFRCFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXFRCFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:05:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42527 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750769AbXFRCFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:05:37 -0400
Date: Sun, 17 Jun 2007 19:05:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Stefan Seyfried <seife@suse.de>
Subject: Re: git-current: slub breaks s2ram with fglrx...
In-Reply-To: <1182095223.3841.28.camel@localhost>
Message-ID: <Pine.LNX.4.64.0706171905090.26668@schroedinger.engr.sgi.com>
References: <1182073786.3841.11.camel@localhost>  <200706171304.46181.rjw@sisk.pl>
 <1182093905.3841.23.camel@localhost>  <6bffcb0e0706170833x36aa33a3x5ff81ba5a112528f@mail.gmail.com>
 <1182095223.3841.28.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you try to boot with "slub_debug" on the kernel command line? That 
may help you to diagnose the problem.

