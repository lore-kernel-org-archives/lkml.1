Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZIPPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZIPPet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZIPPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:34:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:33998 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZIPPeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:34:44 -0400
Date: Wed, 16 Sep 2009 09:34:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
Message-ID: <20090916093446.5ea81b8a@bike.lwn.net>
In-Reply-To: <1253059937.11643.527.camel@desktop>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
	<1253059937.11643.527.camel@desktop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 17:12:17 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> Both times that you've submitted this the patch has been corrupt.. Your
> mailer, or something is adding little "=20" or "=3D" all over.

That looks a lot like *your* mail client not understanding
quoted-printable encoding.  QP can be a pain, but it is a legitimate
encoding; the message in question looks fine in claws.

jon
