Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYAWCWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYAWCWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 21:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYAWCWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 21:22:13 -0500
Received: from fmailhost01.isp.att.net ([207.115.11.51]:36228 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYAWCWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 21:22:13 -0500
X-Originating-IP: [70.152.123.12]
Date: Tue, 22 Jan 2008 20:13:46 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 06/26] atl1: update initialization parameters
Message-ID: <20080122201346.6bb36ca2@osprey.hogchain.net>
In-Reply-To: <4795BDBB.10904@garzik.org>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
	<1199152804-3889-7-git-send-email-jacliburn@bellsouth.net>
	<4795BDBB.10904@garzik.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 04:56:11 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> jacliburn@bellsouth.net wrote:
> > From: Jay Cliburn <jacliburn@bellsouth.net>
> > 
> > Update initialization parameters to match the current vendor driver
> > version 1.2.40.2.

[...]

> ACK without any better knowledge...  but is any addition insight 
> available at all?

No, sorry Jeff.  I simply took the vendor's current driver and matched
his initialization settings.  I can only assume he discovered these
values through lab testing.

For this and the other "conform to vendor driver" patches in this set, I
thought it important to have the in-tree driver match the vendor driver
as closely as possible.  The primary motivations are (1) my belief that
he's in a better position to test the NIC, and (2) to be able to go to
him for assistance occasionally and not be rejected because of
significant differences between his and our drivers.

Jay
