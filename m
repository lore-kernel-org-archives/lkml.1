Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYKBNho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYKBNho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYKBNgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:36:46 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54581 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753358AbYKBNgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:36:45 -0500
Date: Sun, 2 Nov 2008 13:06:00 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: linux-pcmcia@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pcmcia: fix indentation & braces disagreement - add
	braces
Message-ID: <20081102120600.GB14531@comet.dominikbrodowski.net>
Mail-Followup-To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	linux-pcmcia@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0810301301260.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810301301260.7072@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 01:02:54PM +0200, Ilpo Järvinen wrote:
> Broken by d8b0a49da4f2 (pcmcia: deprecate CS_BAD_VCC and
> CS_BAD_VPP).

Applied, thanks!

	Dominik
