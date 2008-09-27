Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbYI0F2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbYI0F2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 01:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYI0F2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 01:28:43 -0400
Received: from tundra.namei.org ([65.99.196.166]:42223 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYI0F2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 01:28:43 -0400
Date: Sat, 27 Sep 2008 15:27:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/6] file capabilities: uninline cap_safe_nice
In-Reply-To: <48DDB5F6.107@kernel.org>
Message-ID: <alpine.LRH.1.10.0809271527190.21405@tundra.namei.org>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
 <48DDB5F6.107@kernel.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Andrew G. Morgan wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> Serge E. Hallyn wrote:
> > This reduces the kernel size by 289 bytes.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> 
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> 

This one makes sense on its own, applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


- James
-- 
James Morris
<jmorris@namei.org>
