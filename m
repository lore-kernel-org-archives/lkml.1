Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZEFXAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZEFXAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZEFXAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:00:40 -0400
Received: from mail.crca.org.au ([67.207.131.56]:34283 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbZEFXAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:00:39 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH 2/5] PM/Suspend: Do not shrink memory before
 suspend
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905070042.01880.rjw@sisk.pl>
References: <200905070040.08561.rjw@sisk.pl>
	 <200905070042.01880.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 07 May 2009 09:01:36 +1000
Message-Id: <1241650896.19600.125.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 00:42 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the shrinking of memory from the suspend-to-RAM code, where
> it is not really necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>


