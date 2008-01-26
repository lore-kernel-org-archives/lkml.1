Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYAZKGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYAZKGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYAZKGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:06:08 -0500
Received: from 8bytes.org ([88.198.83.132]:33643 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYAZKGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:06:07 -0500
Date: Sat, 26 Jan 2008 11:06:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alexey Eremenko <al4321@gmail.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable NestedPaging
Message-ID: <20080126100605.GD21476@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-4-git-send-email-joerg.roedel@amd.com> <2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com> <20080126072556.GB21476@8bytes.org> <7fac565a0801260149j7d6d48demfb49d2bb0d5a952@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fac565a0801260149j7d6d48demfb49d2bb0d5a952@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 11:49:17AM +0200, Alexey Eremenko wrote:
> > Generally I see no problem with it. But at least for NPT I don't see a
> > reason why someone should want to disable it on a VM basis (as far as it
> > works stable). Avi, what do you think?
> >
> 
> 1. This is more user-friendly and easier-to-find
> 
> 2. A lot of people would like to view (and Demo) it side-by-side.
> 
> 3. Useful for BETA-testing of KVM.

Ok, agreed. I will add this feature.

Joerg
