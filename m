Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXGHKZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXGHKZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXGHKY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:24:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbXGHKY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:24:56 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality, performance and maintenance
References: <20070708034952.022985379@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Jul 2007 13:20:18 +0200
In-Reply-To: <20070708034952.022985379@sgi.com>
Message-ID: <p73y7hrywel.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> A cmpxchg is less costly than interrupt enabe/disable

That sounds wrong.

-Andi
