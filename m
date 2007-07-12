Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbXGLHAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbXGLHAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXGLHAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:00:39 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:49130
	"EHLO moonbase" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbXGLHAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:00:39 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RFC] extent mapped page cache
Date: Thu, 12 Jul 2007 00:00:28 -0700
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
References: <20070710210326.GA29963@think.oraclecorp.com>
In-Reply-To: <20070710210326.GA29963@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707120000.28501.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 14:03, Chris Mason wrote:
> This patch aims to demonstrate one way to replace buffer heads with a
> few extent trees...

Hi Chris,

Quite terse commentary on algorithms and data structures, but I suppose
that is not a problem because Jon has a whole week to reverse engineer
it for us.

What did you have in mind for subpages?

Regards,

Daniel
