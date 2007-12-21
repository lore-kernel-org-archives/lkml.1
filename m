Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbXLUFZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbXLUFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 00:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXLUFZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 00:25:17 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:43693 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737AbXLUFZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 00:25:15 -0500
Date: Fri, 21 Dec 2007 14:24:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071221052456.GA30618@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-sh@vger.kernel.org, axboe@kernel.dk
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com> <20071216095019.GA12184@linux-sh.org> <8b67d60712201353y71a85498p9d77f1f21761856c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712201353y71a85498p9d77f1f21761856c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 09:53:54PM +0000, Adrian McMenamin wrote:
> On 16/12/2007, Paul Mundt <lethal@linux-sh.org> wrote:
> > Also, __devinit/__devexit annotations?
> >
> 
> Is there any difference between __init and __devint?

Yes.
