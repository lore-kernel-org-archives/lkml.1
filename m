Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZLWODO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZLWODO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZLWODN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:03:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44509 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755896AbZLWODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:03:13 -0500
Date: Wed, 23 Dec 2009 14:03:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator/lp3971: Storage class should be before const
	qualifier
Message-ID: <20091223140311.GB14455@opensource.wolfsonmicro.com>
References: <1261573997-9126-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261573997-9126-1-git-send-email-tklauser@distanz.ch>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 02:13:17PM +0100, Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
