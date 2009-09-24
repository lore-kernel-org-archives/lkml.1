Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZIXUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZIXUtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZIXUtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:49:20 -0400
Received: from tundra.namei.org ([65.99.196.166]:49996 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZIXUtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:49:20 -0400
Date: Fri, 25 Sep 2009 06:48:49 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] TPM: increase default TPM buffer
In-Reply-To: <1253820466.8653.9.camel@dyn531367.br.ibm.com>
Message-ID: <alpine.LRH.2.00.0909250648370.17037@tundra.namei.org>
References: <1253820466.8653.9.camel@dyn531367.br.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, Rajiv Andrade wrote:

> The TPM Working Group requested this communication buffer increase given that a
> particular TPM vendor can support a TPM_SHA1Start command input bigger than the
> current size.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
