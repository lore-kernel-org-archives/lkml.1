Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXJHRpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXJHRpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXJHRp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:45:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45273 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXJHRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:45:28 -0400
Date: Mon, 8 Oct 2007 19:45:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
In-Reply-To: <20071008173706.GA12026@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8 2007 19:37, Sam Ravnborg wrote:
>snip...
>
>Or maybe we need something much less formal that explain the purpose of the
>four tags we use:

At least formal try:

>Signed-of-by:

* Used by original submitter(s).
* Also used by maintainers to track the patch's path
  (ATM, does not imply "I have look at it in depth")

>Acked-by:
>Tested-by:

* Used by random people to express their (dis)like/experience with the 
patch.

>Reviewed-by:

* I am maintaner or an 'important' person and have had a
  look at it in depth

>Cc:

* Used by original submitter to denote additional maintainers it goes to
* Parties who should be Cced when an a posteriori question comes up


My 2¥.
Jan
