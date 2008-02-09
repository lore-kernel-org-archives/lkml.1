Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbYBIAF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbYBIAF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbYBIAFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:05:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33278 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757970AbYBIAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:05:01 -0500
Date: Fri, 8 Feb 2008 16:05:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Robin Holt <holt@sgi.com>, andrea@qumranet.com, avi@qumranet.com,
       izike@qumranet.com, kvm-devel@lists.sourceforge.net,
       a.p.zijlstra@chello.nl, steiner@sgi.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <20080208155641.2258ad2c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
References: <20080208220616.089936205@sgi.com> <20080208142315.7fe4b95e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
 <20080208233636.GG26564@sgi.com> <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andrew Morton wrote:

> You took it correctly, and I didn't understand the answer ;)

We have done several rounds of discussion on linux-kernel about this so 
far and the IB folks have not shown up to join in. I have tried to make 
this as general as possible.
