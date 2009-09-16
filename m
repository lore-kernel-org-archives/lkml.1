Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZIPQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZIPQiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933538AbZIPQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:38:17 -0400
Received: from fifo99.com ([67.223.236.141]:60797 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbZIPQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:38:16 -0400
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
From: Daniel Walker <dwalker@fifo99.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
In-Reply-To: <20090916093446.5ea81b8a@bike.lwn.net>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
	 <1253059937.11643.527.camel@desktop> <20090916093446.5ea81b8a@bike.lwn.net>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:39:13 -0700
Message-Id: <1253119153.11643.583.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 09:34 -0600, Jonathan Corbet wrote:
> On Tue, 15 Sep 2009 17:12:17 -0700
> Daniel Walker <dwalker@fifo99.com> wrote:
> 
> > Both times that you've submitted this the patch has been corrupt.. Your
> > mailer, or something is adding little "=20" or "=3D" all over.
> 
> That looks a lot like *your* mail client not understanding
> quoted-printable encoding.  QP can be a pain, but it is a legitimate
> encoding; the message in question looks fine in claws.

Shouldn't all patches be sent as plain text untouched? I don't think I
should necessarily need a specific email client to strip off some
characters..

Daniel

