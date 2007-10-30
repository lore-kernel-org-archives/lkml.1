Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXJ3J1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXJ3J1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXJ3J1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:27:11 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36541 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXJ3J1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:27:10 -0400
Date: Tue, 30 Oct 2007 10:26:36 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-serial@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH 0/16] CRIS architecture: Correct compile errors
Message-ID: <20071030092636.GC11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset makes it possible to compile for the
CRIS architecture, at least when applied to the 2.6.23 kernel.

Most patches are trivial, but some are a bit more complex,
like the changes to the CRIS ethernet and serial drivers.

I've separated the changes out to logical components to ease
reviewing. Please send any comments or questions to me and
Mikael Starvik.

Crosscompiled on Debian Etch using gcc version 3.2.1 Axis release R64/1.64.

Best regards,

Jesper

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
