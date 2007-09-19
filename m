Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbXISTlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbXISTlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXISTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:40:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50120 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXISTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:40:52 -0400
Date: Wed, 19 Sep 2007 21:40:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rick Jones <rick.jones2@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@redhat.com>,
       netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
Message-ID: <20070919194050.GE18707@one.firstfloor.org>
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de> <46F15305.2030507@redhat.com> <20070919172653.GB18045@one.firstfloor.org> <46F1608E.7060908@redhat.com> <20070919175700.GC18045@one.firstfloor.org> <46F16418.3070706@redhat.com> <20070919183004.GA18707@one.firstfloor.org> <46F16CC1.9090302@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F16CC1.9090302@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It has hung-on in various places (stacks) as an "accepted" broadcast IP 
> in the receive path, but not the send path for quite possibly decades now.

Well it is valid in Linux for sending.  And who knows who relies on it.

-Andi

