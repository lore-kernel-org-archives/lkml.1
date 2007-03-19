Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXCSQ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXCSQ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964802AbXCSQ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:59:33 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:16306 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXCSQ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:59:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAG9e/kVKhRO4UGdsb2JhbACBZ4VLh2kBASo
From: Dmitry Torokhov <dtor@insightbb.com>
To: Victor Fernandes <Victor.Fernandes@comnet.be>
Subject: Re: New kernel mouse recognition problem
Date: Mon, 19 Mar 2007 12:59:30 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <63140.87.244.133.121.1174080814.squirrel@postino> <39605.87.244.133.121.1174151177.squirrel@postino>
In-Reply-To: <39605.87.244.133.121.1174151177.squirrel@postino>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191259.31104.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Victor,

On Saturday 17 March 2007 13:06, Victor Fernandes wrote:
> Dmitry,
> 
> Thanks for you feedback, sorry for the delay on my reply but because
> I'm not subscribe to the list, only now I saw your message. I hope you
> will be able to see that this message is a follow up on the previous ones.
> If you do not mind can you please Cc directly to me.
> 

I did CC you on my reply but unfortunaltely your mail server did
not like me. Let's see if this one goes through.

> Now to answer your questions.
> The mouse do not works properly, I mean with this that I have the mouse
> pointer on the screen, with gpm and X, but it jumps randomly when used.
> 

Does it help if you boot with "psmouse.proto=exps"? (Is psmouse a built-in
or a module)?
 
-- 
Dmitry
