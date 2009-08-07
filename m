Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZHGPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZHGPz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZHGPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:55:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZHGPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:55:58 -0400
Date: Fri, 7 Aug 2009 16:55:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Regulator: Adding header file for TPS65023
Message-ID: <20090807155558.GJ639@sirena.org.uk>
References: <1249658736-10811-1-git-send-email-anuj.aggarwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249658736-10811-1-git-send-email-anuj.aggarwal@ti.com>
X-Cookie: Sic Transit Gloria Thursdi.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:55:36PM +0530, Anuj Aggarwal wrote:

This is OK but since you'll need to resubmit anyway it might be nice to
consider moving the register & bitfield definitions into the driver file
since they can't be used by any other code.

> +/* DCDC's */

Extra ' here :)
