Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbYI3VzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbYI3VzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYI3VzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:55:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:55894 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752546AbYI3VzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:55:09 -0400
Date: Tue, 30 Sep 2008 23:54:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
cc: Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
In-Reply-To: <20080930230644.107e6428.kristoffer.ericson@gmail.com>
Message-ID: <alpine.LNX.1.10.0809302340190.4022@jikos.suse.cz>
References: <20080930153708.GX18732@tekkaman> <Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz> <20080930230644.107e6428.kristoffer.ericson@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Kristoffer Ericson wrote:

> > I in fact never understood what this maintainers entry meant ... what 
> > is the device in question here?
> I thought mouse was a part of linux-input? Or am I missing something?

It is. Generic mice interface is maintained by Dmitry as part of linux 
input subsystem, and USB mice (usb hid) is maintained by me.

-- 
Jiri Kosina
SUSE Labs
