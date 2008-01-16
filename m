Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbYAPVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbYAPVyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYAPVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:54:13 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48038 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYAPVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:54:12 -0500
X-Sasl-enc: aL3KQF1GNIoOWMVAT5xJ0FOX2ZSbDVPk1JZm4UDyMEaV 1200520451
Date: Wed, 16 Jan 2008 19:54:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: thinkpad_acpi: define _sta only when needed
Message-ID: <20080116215400.GA554@khazad-dum.debian.net>
References: <1200488504-6789-1-git-send-email-hannes@saeurebad.de> <20080116191317.GA29449@khazad-dum.debian.net> <87sl0xcw8s.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sl0xcw8s.fsf@saeurebad.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Johannes Weiner wrote:
> > Johannes, thanks for the patches, but NAK.  A similar group of patches that
> > clean up the _sta and heander file (kills it, actually) has already been
> > sent to Len Brown to be merged for 2.6.25.
> 
> Sorry, I missed to check his tree in advance.  And if the work is
> already done - even better! :)

I don't think Len merged the latest version of the patchset yet, but a
previous version is available in the acpi-test tree.  The latest version was
posted to linux-acpi recently.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
