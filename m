Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZCDA5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZCDA5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCDA5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:57:14 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49671 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZCDA5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:57:13 -0500
From: Dan Smith <danms@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	<1236095764-19325-3-git-send-email-danms@us.ibm.com>
	<1236097332.22399.8.camel@nimitz>
Date: Tue, 03 Mar 2009 16:57:06 -0800
In-Reply-To: <1236097332.22399.8.camel@nimitz> (Dave Hansen's message of "Tue,
	03 Mar 2009 08:22:12 -0800")
Message-ID: <878wnmrtp9.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DH> Did you convince Nathan that this ends up being a good idea?

Technically he hasn't seen this version, but my hopes are not high
that he will change his mind.  If the feedback is that they're not
liked, I'll happily remove them.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

