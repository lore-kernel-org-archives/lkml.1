Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069Ab0AZUdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0AZUdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211Ab0AZUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:33:45 -0500
Received: from 1wt.eu ([62.212.114.60]:54996 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab0AZUdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:33:44 -0500
Date: Tue, 26 Jan 2010 21:27:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: Vishal Rao <vishalrao@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
Message-ID: <20100126202740.GA7248@1wt.eu>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com> <20100126160243.018b87e3@lxorguk.ukuu.org.uk> <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 09:49:18PM +0530, Vishal Rao wrote:
> At least one user of Intel SSDs reports no issues with existing
> kernels and I've read that
> they do NCQ right.

FWIW, I can confirm that both the 40 and 80 GB X25-M V2 work like
a charm on 2.6.32 here (main desktop and netbook).

Willy

