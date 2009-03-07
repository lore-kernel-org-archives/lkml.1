Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZCGM1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZCGM1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 07:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZCGM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 07:27:18 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:42358 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZCGM1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:27:18 -0500
Date: Sat, 7 Mar 2009 13:29:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Hunt <josh@scalex86.org>
Cc: linux-kernel@vger.kernel.org, kiran@scalex86.org, mingo@elte.hu,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCHv2] Fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and using SCM tree
Message-ID: <20090307122913.GA5484@uranus.ravnborg.org>
References: <20090220074531.GF8151@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220074531.GF8151@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 11:45:31PM -0800, Josh Hunt wrote:
> Updated patch with Sam's fixes as per this discussion:
> http://lkml.org/lkml/2009/2/15/18
> 
> Running 'make rpm' fails when CONFIG_LOCALVERSION_AUTO=y and using a kernel
> source tree under SCM.  This is due to KERNELRELEASE being different when the
> initial make is run and when make is run from rpmbuild.
...
Hand applied - your patches continue to be wordwrapped.
Please see if you can fix this next time.

Thanks,
	Sam
