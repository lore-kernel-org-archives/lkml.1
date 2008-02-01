Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYBAJIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYBAJIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYBAJID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:08:03 -0500
Received: from namei.org ([69.55.235.186]:38303 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbYBAJH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:07:59 -0500
Date: Fri, 1 Feb 2008 20:07:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Andrew G. Morgan" <morgan@kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
In-Reply-To: <20080201002837.d84fc029.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0802011941140.16283@us.intercode.com.au>
References: <47A2D439.9050704@kernel.org> <20080201002837.d84fc029.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Andrew Morton wrote:

> Really?  I'd feel a lot more comfortable if yesterday's version 1 had led
> to a stream of comments from suitably-knowledgeable kernel developers which
> indicated that those developers had scrutinised this code from every
> conceivable angle and had declared themselves 100% happy with it.

FWIW, I've reviewed the patch in detail a couple of times, and don't see 
any issues with it that haven't already been raised by Serge.

You can add my reviewed-by.

I think it does need more eyes, and some time baking in -mm.  

File capabilities are at least marked experimental, although it's not 
clear what the criteria would be to unmark them.


- James
-- 
James Morris
<jmorris@namei.org>
