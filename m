Return-Path: <linux-kernel-owner+w=401wt.eu-S1161535AbXEDVwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161535AbXEDVwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161560AbXEDVwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:52:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161535AbXEDVwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:52:20 -0400
Message-ID: <463BAB0F.60304@redhat.com>
Date: Fri, 04 May 2007 17:52:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com> <20070504134212.c18d2d65.akpm@linux-foundation.org>
In-Reply-To: <20070504134212.c18d2d65.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> I'd investigate further, but someone has gone and broken oprofile.
> 

Did you just notice that? Apparently it's been broken since 2.6.21-final.

