Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbXFRLnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbXFRLnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762962AbXFRLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:42:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56075 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762952AbXFRLmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:42:39 -0400
Date: Mon, 18 Jun 2007 13:42:34 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <1182077820.5909.5.camel@iamer-laptop>
Message-ID: <Pine.LNX.4.64.0706181341570.12361@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro> 
 <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
  <1181743734.6163.1.camel@iamer-laptop>  <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
  <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com> 
 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>  <1181750326.6163.6.camel@iamer-laptop>
  <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz>  <1181823597.6136.8.camel@iamer-laptop>
  <Pine.LNX.4.64.0706141425180.23280@twin.jikos.cz> 
 <Pine.LNX.4.64.0706151211210.23280@twin.jikos.cz> 
 <Pine.LNX.4.64.0706151249520.23280@twin.jikos.cz> <1182077820.5909.5.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Islam Amer wrote:

> Yes the last patch fixes everything, amazing! Thanks a lot for this :) 
> That's what I call opensource support... I noticed another button not 
> working the "More" button. I think I already got the idea of fixing 
> these things, not that the "more" button matters anyway but here's the 
> output from this button for the sake of completeness.

Thanks for your feedback, I will tidy the patch up, add support for the 
"More" button (will map it to KEY_NEXT) and will queue it in my tree.

-- 
Jiri Kosina
