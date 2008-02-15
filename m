Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYBONi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYBONi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYBONit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:38:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50872 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYBONis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:38:48 -0500
Date: Fri, 15 Feb 2008 14:38:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 01/14] [ISDN] HiSax: modularize card setup
Message-ID: <20080215133854.GJ1178@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <xxxc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xxxc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:04:04PM -0400, Jeff Garzik wrote:
> Now that the previous no-behavior-change code movement patches have
> occurred, we can easily replace the big per-card "call the setup
> function for <this card>" switch statement with a function pointer.

I do not see the code changes matching the description.
There is no big switch that are gone with this patch.

	Sam
