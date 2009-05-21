Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZEUXfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZEUXfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZEUXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:35:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:53984 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZEUXfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:35:30 -0400
Date: Fri, 22 May 2009 09:35:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com
Subject: Re: [PATCH] IMA: Add __init notation to ima functions
In-Reply-To: <20090521194332.4971.4854.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905220934370.6348@tundra.namei.org>
References: <20090521194332.4971.4854.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Eric Paris wrote:

> A number of IMA functions only used during init are not marked with __init.
> Add those notations so they are freed automatically.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Also applied (neither of these applied cleanly to my next branch, btw).


-- 
James Morris
<jmorris@namei.org>
