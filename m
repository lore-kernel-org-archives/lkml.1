Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYALP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYALP0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYALPZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:25:57 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:59000 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750931AbYALPZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:25:56 -0500
Date: Sat, 12 Jan 2008 16:21:21 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
       Michael Wu <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
Message-ID: <20080112162121.2fc2f507@morte>
In-Reply-To: <4788D24E.30805@hauke-m.de>
References: <477F9890.5050107@hauke-m.de>
	<43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	<47824D25.5090005@hauke-m.de>
	<43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
	<4787F03E.6080605@hauke-m.de>
	<4788D24E.30805@hauke-m.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: No virus found, Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, BODY_SIZE_400_499 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008 15:44:30 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> I have tested kernel 2.6.24-rc7-git4 with the build in rtl8187 module
> and I have the same problem.

Could you please try the wireless-2.6 kernel tree? I think it's fixed
there. Details on how to download that can be found here:
http://linuxwireless.org/en/developers/Documentation/git-guide


--
Ciao
Stefano
