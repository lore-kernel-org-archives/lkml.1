Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYLAJo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYLAJo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 04:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYLAJoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 04:44:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYLAJoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 04:44:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Swappiness fix?
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <200812010435.41540.gene.heskett@gmail.com>
References: <200812010435.41540.gene.heskett@gmail.com>
Message-Id: <20081201184115.1CC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 18:44:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Greetings;
> 
> Has that patch someone pointed me to made it into -rc6?  I have a bit under 9 
> hours uptime on a 4Gb machine, with a gimp session, email and web browsing, 
> and I see I'm 27 megs into swap.  I do not have the patch now, a drive died.
> However, I may still have the email that contained it, I'll check that.
> 
> That patch, IMO should be fast lane'd to make it to .28.

Could you please try to mmotm?
As far as I know, nobody give Tested-by to the fixing patch.

if you can test it, I'm very glad.
thanks.



