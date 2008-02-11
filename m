Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYBKTe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYBKTe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBKTet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:34:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757547AbYBKTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:34:48 -0500
Date: Mon, 11 Feb 2008 11:34:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802111134040.24563@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks conceptually good (I have not looked at the details).

