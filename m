Return-Path: <linux-kernel-owner+w=401wt.eu-S932169Ab0A1Pyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0A1Pyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566Ab0A1Pys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:54:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0A1Pyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:54:47 -0500
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
From: Andi Kleen <andi@firstfloor.org>
References: <1264597747.3607.29.camel@wall-e>
Date: Thu, 28 Jan 2010 16:54:43 +0100
In-Reply-To: <1264597747.3607.29.camel@wall-e> (Stefani Seibold's message of "Wed, 27 Jan 2010 14:09:07 +0100")
Message-ID: <87hbq6dy2k.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> The time of 80 characters punch card and terminals are over, so i would
> be a good thing to set the line length limit to 120. Every display today
> should be able handle this. 
>   
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Full Ack!

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
