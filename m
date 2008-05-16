Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYEPTmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYEPTmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYEPTmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:42:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:15490 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYEPTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:42:40 -0400
Message-ID: <fa686aa40805161242g4295da76sdbebbc1009f041e4@mail.gmail.com>
Date: Fri, 16 May 2008 13:42:39 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH 4/4] [CSB] Add new mpc5200-spi (non-psc) device driver
In-Reply-To: <20080516193618.28030.15219.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193618.28030.15219.stgit@trillian.secretlab.ca>
X-Google-Sender-Auth: 01199f7119ce79f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 1:36 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Unlike the old CSB driver, this driver uses the SPI infrastructure.

er, this comment is *obviously* wrong.  I'll fix it in the next version.

Cheers,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
