Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYCBRRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYCBRRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYCBRRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:17:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:45999 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYCBRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W9GRRfjDtgoMsFlepQRcZjzTnGYWbJ6eAoWAb0kuPAEY4T/9XJ96qsMD29S900Z81qcBOYpvicBU8mHBpplSPPZx1xATlUVs8MDwSWqgudo9GhoGa9+25bCLx23P4xYJlaqH9wpZAJhkIsbuxTIqcDgwg97CaTaKXlptmgPyaeo=
Message-ID: <2c0942db0803020917r3e9985fi626b238c89731921@mail.gmail.com>
Date: Sun, 2 Mar 2008 09:17:34 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: Oops in mac80211:rate_control_pid_tx_status
Cc: "kernel list" <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org,
       "John Linville" <linville@tuxdriver.com>
In-Reply-To: <20080302120441.26c1b8a3@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
	 <20080302120441.26c1b8a3@morte>
X-Google-Sender-Auth: 5afb9e30f292ce4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 3:04 AM, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Sat, 1 Mar 2008 17:05:50 -0800
>  "Ray Lee" <ray-lk@madrabbit.org> wrote:
>
>  > Kernel version 2.6.24+ a little (but pre-rc1).
>  >
>  > I have a wireless base station that I switched from B/G mixed mode to
>  > purely B to try to debug a separate issue with a different device on
>  > my network. As soon as I did that (and on every subsequent boot), the
>  > system oopses as soon as it tries to associate. Switching the base
>  > station back to "mixed" avoids the oops.
>
>  Known and fixed. The fix is in the wireless-testing tree, and I just sent
>  it rebased against 2.6.25-rc3. Please test:
>  http://marc.info/?l=linux-wireless&m=120445495012387&w=2

Will do. Thanks!
