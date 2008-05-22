Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYEVQuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYEVQuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYEVQtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:49:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49533 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754263AbYEVQtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:49:50 -0400
Date: Thu, 22 May 2008 09:49:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: dhowells@redhat.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] nommu: fix ksize() abuse
In-Reply-To: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0805220949370.27587@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does kobjsize exisst for !nommu?


