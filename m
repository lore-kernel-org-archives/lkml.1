Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZBTMFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZBTMFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZBTMFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:05:35 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:51202 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZBTMFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:05:34 -0500
Date: Fri, 20 Feb 2009 13:07:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Hunt <josh@scalex86.org>
Cc: linux-kernel@vger.kernel.org, kiran@scalex86.org, mingo@elte.hu,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCHv2] Fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and using SCM tree
Message-ID: <20090220120727.GA22518@uranus.ravnborg.org>
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

Thanks for resending. I will replace my queued version with this one.
I hope to find time during the weekend to deal with this.

	Sam
