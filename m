Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXBCW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXBCW4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXBCW4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:56:23 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54445 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXBCW4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:56:22 -0500
Message-ID: <45C51310.6070304@student.ltu.se>
Date: Sat, 03 Feb 2007 23:56:16 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
References: <20070203215848.GA10440@Ahmed>
In-Reply-To: <20070203215848.GA10440@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> Hi all,
>
> In CodingStyle Chapter 16 "Function return value and names", why not
> adding a comment about the favorable community way of checking the return
> value. ie:
>
> ret = do_method();
> if (ret) {
>    /* deal with error */
> }
>
> and not other ways like:
>
> if (do_method()) or 
So:

if (is_true()) {
	/* do something */
}

is alright then? If so, I agree, but please make it real clear in the 
document ;)

Richard Knutsson

