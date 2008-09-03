Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYICMjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYICMjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYICMjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:39:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:38911 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYICMjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:39:46 -0400
Date: Wed, 3 Sep 2008 22:39:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [GIT] Fix SELinux memory leak regression for 2.6.27
In-Reply-To: <alpine.LRH.1.10.0809031015260.17746@tundra.namei.org>
Message-ID: <alpine.LRH.1.10.0809032238080.21379@tundra.namei.org>
References: <alpine.LRH.1.10.0809031015260.17746@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, James Morris wrote:

> This is causing recent Fedora systems to die a slow and painful death.  
> Please pull.

Further review has raised an issue with this patch, an updated version 
should be available soon.


- James
-- 
James Morris
<jmorris@namei.org>
