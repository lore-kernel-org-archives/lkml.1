Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZB0BhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZB0BhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZB0Bgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:36:51 -0500
Received: from tundra.namei.org ([65.99.196.166]:3850 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZB0Bgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:36:50 -0500
Date: Fri, 27 Feb 2009 12:36:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] keys: work correctly with user namespaces
In-Reply-To: <20090227002709.GA31049@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0902271236260.18643@tundra.namei.org>
References: <20090227002709.GA31049@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Serge E. Hallyn wrote:

> Hi James,
> 
> the following 4 patches apply on top of current security-testing-2.6 next
> branch.  They implement strict separation of keys in different user
> namespaces.  Do you mind sticking these in the security-testing tree?
> 
> With these patches I can run the keyutils-tests simultaneously in two
> namespaces with no problems or failures.
> 

Applied.

-- 
James Morris
<jmorris@namei.org>
