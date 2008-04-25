Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYDYNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYDYNHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYDYNHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 09:07:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42361 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYDYNHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 09:07:04 -0400
Date: Fri, 25 Apr 2008 16:05:51 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: David Miller <davem@davemloft.net>
cc: shigeonx@gmail.com, andi@firstfloor.org,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: XTP for 2.6.25
In-Reply-To: <20080425.015508.254917794.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0804251558550.1888@wrl-59.cs.helsinki.fi>
References: <18b669d80804250059m793f3f56xc4fdb8bad949fa3@mail.gmail.com>
 <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
 <18b669d80804250151h516788cdqc7931a7ab5a195de@mail.gmail.com>
 <20080425.015508.254917794.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, David Miller wrote:

> From: "Shigeo N" <shigeonx@gmail.com>
> Date: Fri, 25 Apr 2008 17:51:49 +0900
> 
> > One host(sender) is 2.6.25, but the other(receiver) is 2.6.18.
> > I will evaluate again after I upgrade it to 2.6.25.
> 
> The bug fix isn't in 2.6.25 either.

Sure it is, or git is lying:

$ git-describe dd9e0dda66ba38a2ddd1405ac279894260dc5c36
v2.6.25-rc8-1190-gdd9e0dd

> [ Upstream commit: dd9e0dda66ba38a2ddd1405ac279894260dc5c36 ]


-- 
 i.
