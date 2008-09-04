Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYIDOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYIDOGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYIDOGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:06:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52342 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYIDOGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:06:07 -0400
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 07:05:54 -0700
Message-Id: <1220537154.23620.34.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, just like the I/O controller patches, we surely can't just throw
patch sets back and forth at each other.  We're also sure to wear out
any potential reviewers, especially on LKML.

The differences you've described between this and Oren's patches are
pretty small, all things considered.  Would you be willing to simply
help with Oren's patches or port things over from this set instead of
working on a completely disjoint set?

-- Dave

