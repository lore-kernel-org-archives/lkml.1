Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0AZQGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0AZQGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331Ab0AZQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:06:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58189 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317Ab0AZQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:06:10 -0500
Date: Tue, 26 Jan 2010 16:02:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vishal Rao <vishalrao@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, vishalrao@gmail.com,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
Message-ID: <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
In-Reply-To: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should work with 64, 128 (tested) and 256 GB capacities with any
> firmware versions in
> drivers/ata/libata-core.c because of ATA errors in dmesg, hangs and
> filesystem corruption.

If you've only tested one type why list all three ? Also you've not
listed a firmware version so do you know which are affected ?

What controllers did you test with ?

Alan
