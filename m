Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbXIOEtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbXIOEtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 00:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbXIOEte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 00:49:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36105 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbXIOEtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 00:49:33 -0400
Message-ID: <46EB645B.6000302@us.ibm.com>
Date: Fri, 14 Sep 2007 21:49:31 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Trace code and documentation
References: <46E9CB14.7060000@us.ibm.com> <20070914175027.GA3642@uranus.ravnborg.org>
In-Reply-To: <20070914175027.GA3642@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Hi David.
>
> A random comment to the code.
> Several of the struct file_operations are not declared static as
> they should be.
>
> Btw. it looks good from a coding style point-of-view.
>
> About the name what about ktrace??
>
> 	Sam
>
>   
Thanks for the comment. I sure don't want to change the name a forth 
time, can we live with "trace"?
