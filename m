Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbXE2RKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbXE2RKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXE2RJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:09:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56595 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753596AbXE2RJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:09:56 -0400
Date: Tue, 29 May 2007 10:09:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jiri Kosina <jikos@jikos.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB-related panic
In-Reply-To: <Pine.LNX.4.64.0705281858200.8531@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0705291009040.23611@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705281858200.8531@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Jiri Kosina wrote:

> when trying to reproduce a bugreport in bugzilla, I am experiencing panics 
> upon boot. The .config which causes this is at [1]

Please reboot with "slub_debug" to identify what causes this.

