Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZG1Ls5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZG1Ls5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZG1Ls4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:48:56 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:51237 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZG1Lsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:48:55 -0400
Date: Tue, 28 Jul 2009 12:48:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>, akpm@linux-foundation.org,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
Message-ID: <20090728114830.GA1090@console-pimps.org>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:51:07AM +0200, Guennadi Liakhovetski wrote:
> If the platform device has a clock associated with the tmio-mmc device, 
> use it.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Magnus Damm <damm@opensource.se>
> ---
> 

Looks fine to me, though it's probably best to wait for an ACK from Ian.

Reviewed-by: Matt Fleming <matt@console-pimps.org>

