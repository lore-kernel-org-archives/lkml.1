Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYBJTUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYBJTUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYBJTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:20:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11916 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYBJTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:20:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ffrYZ8jwQWnxM7t4DiJ29xXZgtfqW60Pc0fwpVSakh+3VY5gECqxT26Be0IFuXX3T
	V12yi99XibfuIpNtEbong==
Date: Sun, 10 Feb 2008 11:19:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Habets <errandir_news@mph.eclipse.co.uk>
cc: Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc compile error
In-Reply-To: <20080210153355.GA6737@palantir8>
Message-ID: <alpine.DEB.1.00.0802101117510.5043@chino.kir.corp.google.com>
References: <20080207231230.GE7198@cs181133002.pp.htv.fi> <alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com> <20080210153355.GA6737@palantir8>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008, Martin Habets wrote:

> This still gives build errors with CGROUP_MEM_CONT off.
> Some ifdef-ing will fix that.
> 

Please try Linus' latest git that includes 60c12b12 (from yesterday) that 
fixes this issue.

		David
