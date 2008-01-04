Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYADRUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYADRUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYADRU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:20:28 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:48015 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbYADRU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:20:27 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to "unsupported" if wakeup feature isn't supported by a device
Date: Fri, 4 Jan 2008 18:20:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Olivier Galibert <galibert@pobox.com>,
       Alan Stern <stern@rowland.harvard.edu>, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org
References: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <Pine.LNX.4.44L0.0801041136490.4078-100000@iolanthe.rowland.org> <20080104165214.GA30672@dspnet.fr.eu.org>
In-Reply-To: <20080104165214.GA30672@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041820.24819.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Januar 2008 17:52:14 schrieb Olivier Galibert:
> On Fri, Jan 04, 2008 at 11:38:29AM -0500, Alan Stern wrote:
> > How about changing it to say "unavailable"?  That doesn't imply 
> > permanence.
> 
> How about not changing a userland-visible interface gratuitously?

Very good idea.

	Regards
		Oliver
