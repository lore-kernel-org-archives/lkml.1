Return-Path: <linux-kernel-owner+w=401wt.eu-S934971AbZDBGBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971AbZDBGBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZDBGAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:00:46 -0400
Received: from sous-sol.org ([216.99.217.87]:40827 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751612AbZDBGAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:00:45 -0400
Date: Wed, 1 Apr 2009 23:00:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       rusty@rustcorp.com.au, netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090402060024.GY18394@sequoia.sous-sol.org>
References: <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <20090401204039.GR18394@sequoia.sous-sol.org> <49D3D88E.3090009@novell.com> <20090401212830.GT18394@sequoia.sous-sol.org> <49D3E649.7000906@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3E649.7000906@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:

<snip nice list>

> I cant think of more examples right now, but I will update this list
> if/when I come up with more.  I hope that satisfactorily answered your
> question, though!

Yes, that helps, thanks.

There's still the simple issue of guest/host interface widening w/ kernel
resident backend where a plain ol' bug (good that you thought about the
isolation) can take out more than single guest.  Always the balance... ;-)
