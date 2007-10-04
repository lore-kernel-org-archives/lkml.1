Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbXJDPYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbXJDPYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbXJDPYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:24:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44110 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXJDPYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:24:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Pietikainen <pp@ee.oulu.fi>
Subject: Re: 2.6.23-rc8-git2 possible recursive locking when running screen
Date: Thu, 4 Oct 2007 17:39:12 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071003092408.GA17356@ee.oulu.fi>
In-Reply-To: <20071003092408.GA17356@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041739.12726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 October 2007 11:24, Pekka Pietikainen wrote:
> Seen this a few times lately on a machine running rawhide when running
> screen (and doing "something", it's not automatic. And box works just fine).
> I think I saw this a few weeks back, so it's not a new regression.

Did it happen with 2.6.22?

Rafael
