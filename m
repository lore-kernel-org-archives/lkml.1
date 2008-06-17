Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYFQNk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYFQNk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbYFQNkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:40:18 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4619 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495AbYFQNkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:40:17 -0400
Date: Tue, 17 Jun 2008 15:32:34 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
Message-ID: <20080617133234.GE2397@deprecation.cyrius.com>
References: <20080616150550.GA16086@deprecation.cyrius.com> <48568503.90607@codemonkey.ws> <20080617123918.GA2397@deprecation.cyrius.com> <4857B92F.9020309@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4857B92F.9020309@codemonkey.ws>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori <anthony@codemonkey.ws> [2008-06-17 08:16]:
> VMware is a binary kernel module that's out of kernel.  KVM is not
> misbehaving and the fact that VMware breaks when the KVM module is
> loaded isn't our problem.  If they submitted their code for
> inclusion in  mainline, we could possibly come up with solution for
> arbitrating who is  using VT.

I feared I'd get a response like this.  But unless this is a known
issue in VMware (which I don't think it is), you don't know whether
it's not a bug in kvm-intel.

-- 
Martin Michlmayr
http://www.cyrius.com/
