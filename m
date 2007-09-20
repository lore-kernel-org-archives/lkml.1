Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXITRhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXITRhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXITRhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:37:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49806 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbXITRhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:37:01 -0400
Date: Thu, 20 Sep 2007 10:37:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ebiederm@xmission.com
cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten
 (sysfs?)
In-Reply-To: <Pine.LNX.4.64.0709201019510.8283@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0709201036190.8283@schroedinger.engr.sgi.com>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru>
 <20070919123954.fb552e80.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com>
 <20070920075353.GA6781@localhost.sw.ru> <Pine.LNX.4.64.0709201019510.8283@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Christoph Lameter wrote:

> Eric: Anything that comes to mind in sysfs?

Arg. Forget it. Its likely SLUB mm related.
