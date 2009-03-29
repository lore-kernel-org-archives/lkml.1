Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZC2MA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZC2MA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZC2MAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:00:49 -0400
Received: from nn7.de ([85.214.94.156]:40365 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZC2MAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:00:48 -0400
Subject: Re: enabling kms for i915 disables brightness control and xrandr
From: Soeren Sonnenburg <sonne@debian.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090329110143.GA9591@sucs.org>
References: <1238322841.4185.36.camel@localhost>
	 <20090329110143.GA9591@sucs.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 29 Mar 2009 14:00:40 +0200
Message-Id: <1238328040.4185.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 12:01 +0100, Sitsofe Wheeler wrote:
> On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg wrote:
> > 
> > I am not sure if this is just a user error/ too old userspace problem,
> 
> Which version of X intel driver are you running?
> http://lkml.org/lkml/2009/2/27/363 suggests you will have unsupported
> problems unless it is 2.6.2 or higher...

Using 2.6.3 things became a lot faster with UXA, but the brightness
(only possible to set via setpci) and xrandr problems (modes missing)
are still there...

Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
