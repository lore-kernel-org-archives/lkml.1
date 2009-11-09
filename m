Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZKIHcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZKIHcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZKIHcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:32:19 -0500
Received: from isilmar.linta.de ([213.133.102.198]:36959 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752664AbZKIHcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:32:18 -0500
Date: Mon, 9 Nov 2009 08:32:23 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: pcmcia tree build warning
Message-ID: <20091109073223.GB20696@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20091109145451.c9f1c4c3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109145451.c9f1c4c3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

this issue just got fixed by hiding it behind the driver-specific
DEBUG define -- thanks! :)

Best,
	Dominik
