Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab0CJFAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:00:49 -0500
Received: from tundra.namei.org ([65.99.196.166]:34439 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0CJFAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:00:47 -0500
Date: Wed, 10 Mar 2010 16:00:46 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "zohar@us.ibm.com" <zohar@us.ibm.com>
Subject: Re: [PATCH] security/ima: replace gcc specific __FUNCTION__ with
 __func__
In-Reply-To: <0D753D10438DA54287A00B027084269763682CE03C@AUSP01VMBX24.collaborationhost.net>
Message-ID: <alpine.LRH.2.00.1003101600330.23261@tundra.namei.org>
References: <0D753D10438DA54287A00B027084269763682CE03C@AUSP01VMBX24.collaborationhost.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, H Hartley Sweeten wrote:

> As noted by checkpatch.pl, __func__ should be used instead of gcc
> specific __FUNCTION__.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mimi Zohar <zohar@us.ibm.com>
> Cc: James Morris <jmorris@namei.org>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
