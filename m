Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXC1Czi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXC1Czi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXC1Czi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:55:38 -0400
Received: from gw.goop.org ([64.81.55.164]:57716 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXC1Czh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:55:37 -0400
Message-ID: <4609D92A.3050104@goop.org>
Date: Tue, 27 Mar 2007 19:55:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: smart gcc inliner...
References: <46093349.7060401@agmk.net> <p73ircm4odz.fsf@bingen.suse.de>
In-Reply-To: <p73ircm4odz.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> init functions should only ever be called from other init functions.
>
> So this should not happen. If it happens the annotations need to be fixed.
>   

I've seen some versions of gcc inline weak functions too.

    J
