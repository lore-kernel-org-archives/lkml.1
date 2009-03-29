Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZC2LBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZC2LBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZC2LBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:01:46 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:32990 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZC2LBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:01:46 -0400
Date: Sun, 29 Mar 2009 12:01:43 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: enabling kms for i915 disables brightness control and xrandr
Message-ID: <20090329110143.GA9591@sucs.org>
References: <1238322841.4185.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238322841.4185.36.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg wrote:
> 
> I am not sure if this is just a user error/ too old userspace problem,

Which version of X intel driver are you running?
http://lkml.org/lkml/2009/2/27/363 suggests you will have unsupported
problems unless it is 2.6.2 or higher...

-- 
Sitsofe | http://sucs.org/~sits/
